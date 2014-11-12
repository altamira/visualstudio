
-------------------------------------------------------------------------------
--sp_helptext pr_geracao_mrp_carteira_pedidos
-------------------------------------------------------------------------------
--pr_geracao_mrp_carteira_pedidos							
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : 
--Data             : 11.06.2010
--Alteração        : 26.08.2010 - Ajustes Diversos - Carlos Fernandes
--
-- 03.09.2010 - Ajustes Diversos - Carlos Fernandes
-- 16.09.2010 - Geração por seleção de Pedido de Venda - Carlos Fernandes
-- 09.11.2010 - Ajustes diveros - Carlos
-- 23.11.2010 - Verificação do Flag do cadastro do Produto - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_geracao_mrp_carteira_pedidos
@ic_parametro int      = 0,
@dt_inicial   datetime = '',
@dt_final     datetime = '',
@cd_usuario   int      = 0,
@cd_plano     int      = 0,
@ic_selecao   char(1)  = 'N'

as

--plano_mrp_composicao

declare @cd_plano_mrp    int
declare @Tabela	         varchar(80)
declare @dt_hoje         datetime
declare @cd_departamento int
declare @cd_fase_produto int

set @dt_hoje = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)

--Fase do Produto

select
  @cd_fase_produto = isnull(cd_fase_produto,0)
from
  parametro_comercial pc with (nolock) 
where
  cd_empresa = dbo.fn_empresa()

--Geração

if @ic_parametro = 0
begin

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Plano_MRP' as varchar(50))

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_plano_mrp', @codigo = @cd_plano_mrp output
	
  while exists(Select top 1 'x' from Plano_MRP where cd_plano_mrp = @cd_plano_mrp)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_plano_mrp', @codigo = @cd_plano_mrp output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_plano_mrp, 'D'
  end

  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_plano_mrp, 'D'


--Departamento

select
  @cd_departamento = isnull(cd_departamento,null)
from
  egisadmin.dbo.usuario with (nolock) 
where
  cd_usuario = @cd_usuario

--select * from origem_plano_mrp
--select * from status_plano_mrp

select
  @cd_plano_mrp         as cd_plano_mrp,
  case when @ic_selecao = 'N' then 
  'Carteira de Pedidos'
  else
  'Pedido de Venda'
  end                   as nm_plano_mrp,
  @dt_hoje              as dt_plano_mrp,
  null                  as qt_plano_mrp,
  (select top 1
    op.cd_origem_plano_mrp
  from
    origem_plano_mrp op with (nolock) 
  where
    isnull(ic_carteira_origem,'N') = 'S'
  )                     as cd_origem_plano_mrp,
  1                     as cd_status_plano_mrp,
  @cd_usuario           as cd_usuario,
  getdate()             as dt_usuario,
  cast('' as varchar)   as nm_obs_plano_mrp,
  @cd_departamento      as cd_departamento,
  'N'                   as ic_gerado_plano_mrp,
  'N'                   as ic_processo_plano,
  'N'                   as ic_req_compra_plano,
  'N'                   as ic_req_interna_plano


into
  #Plano_MRP

insert into
  Plano_MRP
select
  * 
from
  #Plano_MRP

drop table #Plano_MRP

---------------------------------------------------------------------------------------------------
select
  @cd_plano_mrp              as cd_plano_mrp,
  identity(int,1,1)          as cd_item_plano_mrp,
  pvi.cd_produto,
  case when isnull(p.cd_fase_produto_baixa,0)=0 
  then
    @cd_fase_produto
  else
    p.cd_fase_produto_baixa
  end                        as cd_fase_produto,
  pvi.qt_saldo_pedido_venda  as qt_plano_mrp,
  @cd_usuario                as cd_usuario,
  getdate()                  as dt_usuario,
  pvi.cd_pedido_venda,
  pvi.cd_item_pedido_venda,
  null                       as cd_requisicao_compra,
  null                       as cd_requisicao_interna,
  null                       as cd_processo,
  null                       as cd_previsao_venda

into
  #plano_mrp_composicao

from
  pedido_venda_item pvi      with (nolock) 
  inner join pedido_venda pv with (nolock) on pv.cd_pedido_venda = pvi.cd_pedido_venda
  inner join produto p       with (nolock) on p.cd_produto       = pvi.cd_produto

where
  --isnull(pvi.ic_controle_pcp_pedido,'N')='S' 
  ( isnull(pvi.ic_controle_pcp_pedido,'N')='S' or isnull(p.ic_pcp_produto,'N')='S' )
  and isnull(pvi.qt_saldo_pedido_venda,0)>0 
  and pvi.dt_cancelamento_item is null -- Não pode ser Cancelado
  and pvi.cd_pedido_venda not in ( select cd_pedido_venda 
                                   from
                                     plano_mrp_composicao prc with (nolock) 
                                   where
                                     prc.cd_pedido_venda      = pvi.cd_pedido_venda and 
                                     prc.cd_item_pedido_venda = pvi.cd_item_pedido_venda)  
  --seleção de pedidos de vendas

  and isnull(pvi.ic_sel_mrp_item_pedido,'N') = case when @ic_selecao = 'N'
                                               then isnull(pvi.ic_sel_mrp_item_pedido,'N') else 'S' end 
                                                                          
--   and pvi.cd_pedido_venda = 10461
--   and pvi.cd_item_pedido_venda = 1

--select * from pedido_venda_item where cd_pedido_venda = 900341

order by
  pvi.dt_entrega_vendas_pedido


insert into
  plano_mrp_composicao
select
  *
from
  #plano_mrp_composicao


declare @qt_plano_mrp int

set @qt_plano_mrp = 0

select
  @qt_plano_mrp = isnull(count(cd_produto),0)
from
  #plano_mrp_composicao

group by
  cd_produto  

--Atualiza a Quantidade de Produtos para Produção

update
  plano_mrp
set
  qt_plano_mrp = @qt_plano_mrp
from
  plano_mrp
where
  cd_plano_mrp = @cd_plano_mrp 

--Verifica se houve pedido para processar

if @qt_plano_mrp=0 
begin
  delete from plano_mrp 
  where
  cd_plano_mrp = @cd_plano_mrp 

end
else
  --Gera a Lista de Necessidade-------------------------------------------------------------------

  exec pr_mrp_calculo_geral 9,@dt_inicial,@dt_final,'S',@cd_plano_mrp,@cd_usuario

------------------------------------------------------------------------------

--select * from tipo_produto_projeto


end

------------------------------------------------------------------------------
--Deleção
------------------------------------------------------------------------------

if @ic_parametro = 1 and @cd_plano>0 
begin

  delete from plano_mrp_necessidades where cd_plano_mrp = @cd_plano
  delete from plano_mrp_composicao   where cd_plano_mrp = @cd_plano
  delete from plano_mrp              where cd_plano_mrp = @cd_plano
 

end
  

--select * from pedido_venda_item 

--select cd_tipo_produto_projeto,* from produto_processo
--select * from tipo_produto_projeto

