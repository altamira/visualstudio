
-------------------------------------------------------------------------------
--sp_helptext pr_gera_prestacao_conta_moeda
-------------------------------------------------------------------------------
--pr_gera_prestacao_conta_moeda
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Gera a Prestação de Contas das Moedas do Adiantamento
--Data             : 01/05/2007
--Alteração        : 18.10.2007 
------------------------------------------------------------------------------
create procedure pr_gera_prestacao_conta_moeda
@cd_prestacao int = 0,
@cd_usuario   int = 0
as

--select * from prestacao_conta_moeda
--select * from prestacao_conta

delete from prestacao_conta_moeda where cd_prestacao = @cd_prestacao and
                                        isnull(ic_tipo_lancamento,'M') = 'A'

declare @cd_prestacao_moeda int

set @cd_prestacao_moeda = 0

declare @Tabela		     varchar(80)

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Prestacao_Conta_Moeda' as varchar(50))

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_prestacao_moeda', @codigo = @cd_prestacao_moeda output
	
  while exists(Select top 1 'x' from Prestacao_Conta_Moeda where cd_prestacao_moeda = @cd_prestacao_moeda)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_prestacao_moeda', @codigo = @cd_prestacao_moeda output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_prestacao_moeda, 'D'
  end


Select
  @cd_prestacao_moeda as cd_prestacao_moeda,
  sa.cd_prestacao,
  sa.cd_solicitacao,
  sa.cd_requisicao_viagem,
  sa.dt_solicitacao,
  sa.vl_adiantamento,
  sa.vl_total_moeda_solicitacao,
  sa.cd_moeda,
  isnull(sa.vl_cotacao_solicitacao,1) as vl_cotacao_solicitacao

into
  #Adiantamento 
from
  Solicitacao_Adiantamento SA with(nolock) 
  left join Solicitacao_Adiantamento_baixa sab on (sab.cd_solicitacao = sa.cd_solicitacao)
where
  sa.cd_prestacao = @cd_prestacao

--select * from #Adiantamento

select
  @cd_prestacao_moeda                  as cd_prestacao_moeda,
  pc.cd_prestacao,
  sa.cd_moeda                          as cd_moeda,
  sa.dt_solicitacao                    as dt_prestacao_moeda,
  isnull(sa.vl_total_moeda_solicitacao,
         sa.vl_adiantamento)           as vl_prestacao_moeda,
  isnull(sa.vl_cotacao_solicitacao,1)  as vl_cotacao_prestacao_moeda,
  'Geração Automática PC'              as nm_obs_prestacao_moeda,
  @cd_usuario                          as cd_usuario,
  getdate()                            as dt_usuario,
  'A'                                  as ic_tipo_lancamento,
  isnull(sa.vl_total_moeda_solicitacao * 
         sa.vl_cotacao_solicitacao,0)  as vl_total_prestacao_moeda,
  0.00                                 as vl_moeda_convertida,
  identity(int,1,1)                    as cd_controle,
  sa.cd_solicitacao                    as cd_solicitacao
into
  #prestacao_conta_moeda
from
  prestacao_conta pc 
  inner join #Adiantamento sa on sa.cd_prestacao = pc.cd_prestacao
where
  pc.cd_prestacao = @cd_prestacao

update
  #prestacao_conta_moeda
set
  cd_prestacao_moeda = cd_controle + @cd_prestacao_moeda

insert into prestacao_conta_moeda
select
  *
from
  #prestacao_conta_moeda

drop table #prestacao_conta_moeda

-- limpeza da tabela de código
exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_prestacao_moeda, 'D'


