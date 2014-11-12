
-------------------------------------------------------------------------------
--sp_helptext pr_atualiza_custo_moeda_produto
-------------------------------------------------------------------------------
--pr_atualiza_custo_moeda_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Atualização do Custo Previsto dos Produtos em Outra Moeda
--Data             : 08.10.2007
--Alteração        : 27.10.2007 - Acerto para tirar Pis e Cofins do Cálculo - Carlos Fernandes
-- 09.01.2008 - Gravação da Tabela de Custo Histórico - Carlos Fernandes
---------------------------------------------------------------------------------------------------------------

create procedure pr_atualiza_custo_moeda_produto

@cd_produto    int      = 0,
@dt_base_custo datetime = null,
@ic_atualiza   char(1)  = 'N',
@cd_moeda      int      = 0,
@cd_usuario    int      = 0

as

declare @pc_pis    decimal(25,4)
declare @pc_cofins decimal(25,4)

set @pc_cofins = (7.6/100)
set @pc_pis    = (1.65/100)


--Temporariamente
set @cd_moeda = 2

if @dt_base_custo is null
begin
  set @dt_base_custo = getdate()
end

set @dt_base_custo = cast(convert(int,@dt_base_custo,103) as datetime)

declare @vl_custo_produto_previsto float

select
  pc.cd_produto,
  pc.vl_custo_produto,
  dbo.fn_vl_moeda_periodo(@cd_moeda,@dt_base_custo)  as vl_cotacao,
  vl_custo_previsto_produto = round( ( pc.vl_custo_produto - ( pc.vl_custo_produto * @pc_cofins + pc.vl_custo_produto * @pc_pis )) / dbo.fn_vl_moeda_periodo(2,@dt_base_custo),4),
  isnull(ph.cd_produto_historico,0) as cd_produto_historico,
  p.cd_grupo_produto

into
  #Custo_Produto_Historico
from
  Produto_Custo  pc 
  inner join produto p                 on p.cd_produto                 = pc.cd_produto
  left outer join produto_historico ph on ph.cd_produto                = pc.cd_produto  and 
                                          ph.dt_historico_produto      = @dt_base_custo and
                                          ph.ic_tipo_historico_produto = 'C'
where
  pc.cd_produto = case when @cd_produto = 0 then pc.cd_produto else @cd_produto end and
  isnull(pc.ic_custo_moeda_produto,'N') = 'S'

--select * from #Custo_Produto_Historico

update
  produto_custo
set
  vl_custo_previsto_produto = isnull(x.vl_custo_previsto_produto,0) 
from
  produto_custo pc
  inner join #Custo_Produto_Historico x on x.cd_produto = pc.cd_produto

--Atualiza a Tabela de Histórico de Preço de Produto ( Reajuste / Cálculo )

select
  @dt_base_custo                 as dt_historico_produto,
  cd_grupo_produto               as cd_grupo_produto,
  cd_produto                     as cd_produto,
  vl_custo_previsto_produto      as vl_historico_produto,
  null                           as cd_tipo_reajuste,
  null                           as cd_tipo_tabela_preco,
  @cd_moeda                      as cd_moeda,
  @cd_usuario                    as cd_usuario,
  getdate()                      as dt_usuario,
  null                           as cd_motivo_reajuste,
  --Chave da Tabela
  isnull(cd_produto_historico,0) as cd_produto_historico,
  'C'                            as ic_tipo_historico_produto,
  identity(int,1,1)              as cd_controle 

into 
  #produto_historico
from
  #Custo_Produto_Historico

--select * from produto_historico
--delete from produto_historico

--Atualização dos Custos

update
  produto_historico
set
  vl_historico_produto = isnull(ph.vl_historico_produto,0)
from
  produto_historico p
  inner join #produto_historico ph on ph.cd_produto                = p.cd_produto           and 
                                      ph.dt_historico_produto      = p.dt_historico_produto and
                                      ph.ic_tipo_historico_produto = p.ic_tipo_historico_produto  
where
  isnull(ph.cd_produto_historico,0)<>0

delete from #produto_historico where cd_produto_historico > 0


  declare @Tabela		     varchar(50)
  declare @cd_controle               int
  declare @cd_produto_historico      int

  -- Nome da Tabela usada na geração e liberação de códigos

  set @Tabela = cast(DB_NAME()+'.dbo.Produto_Historico' as varchar(50))

  while exists( select top 1 cd_controle from #produto_historico )
  begin
    select
      @cd_controle = cd_controle
    from
      #produto_historico

    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_produto_historico', @codigo = @cd_produto_historico output
	
    while exists(Select top 1 'x' from produto_historico where cd_produto_historico = @cd_produto_historico)
    begin
      exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_produto_historico', @codigo = @cd_produto_historico output
      -- limpeza da tabela de código
      exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_produto_historico, 'D'
    end

    insert into
       produto_historico
    select
      @dt_base_custo            as dt_historico_produto,
      cd_grupo_produto,
      cd_produto,
      vl_historico_produto,
      cd_tipo_reajuste,
      cd_tipo_tabela_preco,
      cd_moeda,
      cd_usuario,
      dt_usuario,
      cd_motivo_reajuste,
      @cd_produto_historico    as cd_produto_historico,
      ic_tipo_historico_produto
    from
      #produto_historico
    where
      cd_controle = @cd_controle
    
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_produto_historico, 'D'

    delete from #produto_historico where cd_controle = @cd_controle

  end

  drop table #produto_historico
  drop table #Custo_Produto_Historico

