
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_mrp_carteira_pedidos
-------------------------------------------------------------------------------
--pr_consulta_mrp_carteira_pedidos						
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
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_consulta_mrp_carteira_pedidos
@ic_parametro int      = 0,
@dt_inicial   datetime = '',
@dt_final     datetime = '',
@cd_usuario   int      = 0

as

--plano_mrp_composicao

declare @dt_hoje         datetime
declare @cd_fase_produto int

set @dt_hoje = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)

--Fase do Produto

select
  @cd_fase_produto = isnull(cd_fase_produto,0)
from
  parametro_comercial pc
where
  cd_empresa = dbo.fn_empresa()


----------------------------------------------------------------------------------
--Mostra os Pedidos de Vendas
----------------------------------------------------------------------------------

select
  identity(int,1,1)                      as cd_controle,
  pv.cd_pedido_venda,
  pv.dt_pedido_venda,
  c.nm_fantasia_cliente,
  pvi.cd_item_pedido_venda,
  pvi.qt_saldo_pedido_venda,
  pvi.dt_entrega_vendas_pedido,
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  um.sg_unidade_medida

into
  #CarteiraMRP

from
  pedido_venda_item pvi             with (nolock) 
  inner join pedido_venda pv        with (nolock) on pv.cd_pedido_venda   = pvi.cd_pedido_venda
  inner join produto p              with (nolock) on p.cd_produto         = pvi.cd_produto
  left outer join Cliente c         with (nolock) on c.cd_cliente         = pv.cd_cliente
  left outer join Unidade_Medida um with (nolock) on um.cd_unidade_medida = p.cd_unidade_medida
  left outer join Produto_Saldo  ps with (nolock) on ps.cd_produto        = pvi.cd_produto and
                                                     ps.cd_fase_produto   = case when isnull(p.cd_fase_produto_baixa,0)>0
                                                     then
                                                        p.cd_fase_produto_baixa
                                                     else
                                                        @cd_fase_produto
                                                     end
where
  isnull(pvi.ic_controle_pcp_pedido,'N')='S' 
  and isnull(pvi.qt_saldo_pedido_venda,0)>0 
  and pvi.dt_cancelamento_item is null -- Não pode ser Cancelado
  and pvi.cd_pedido_venda not in ( select cd_pedido_venda 
                                   from
                                     plano_mrp_composicao prc with (nolock) 
                                   where
                                     prc.cd_pedido_venda      = pvi.cd_pedido_venda and 
                                     prc.cd_item_pedido_venda = pvi.cd_item_pedido_venda)  

  --and pvi.cd_pedido_venda = 10461

order by
  pvi.dt_entrega_vendas_pedido



if @ic_parametro = 0 
begin
  select
    *
  from
    #CarteiraMRP
  order by
    dt_entrega_vendas_pedido


end


------------------------------------------------------------------------------------

if @ic_parametro = 1
begin
  select
    *
  from
    #CarteiraMRP
  where
    dt_entrega_vendas_pedido between @dt_inicial and @dt_final
  order by
    dt_entrega_vendas_pedido


end



