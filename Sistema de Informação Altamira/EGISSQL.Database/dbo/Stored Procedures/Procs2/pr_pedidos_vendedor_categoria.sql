-----------------------------------------------------------------------------------
--pr_proposta_vendedor_categoria
-----------------------------------------------------------------------------------
--GBS-Global Business Solution Ltda.                                           2006
-----------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  
--Autor        : Daniel C. neto. 
--Objetivo     : Consulta de Pedidos por vendedor e Categoria
--Data         : 16/11/2006
--             : 
-- Atualizado  : 16.04.2009 - Código do produto/Fantasia - Carlos Fernandes
--------------------------------------------------------------------------------------

create procedure pr_pedidos_vendedor_categoria
@cd_vendedor int,
@cd_mapa    varchar(10),
@dt_inicial datetime,
@dt_final   datetime,
@cd_moeda   int = 1
as

declare @vl_moeda float


set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


--select * from pedido_venda_item

select a.cd_pedido_venda, 
       a.dt_pedido_venda, 
       b.cd_item_pedido_venda, 
       b.qt_item_pedido_venda, 
       b.nm_produto_pedido,
       b.qt_item_pedido_venda*b.vl_unitario_item_pedido / @vl_moeda as 'total',
       b.dt_entrega_fabrica_pedido,
       b.qt_saldo_pedido_venda,
       cli.nm_fantasia_vendedor,
       um.sg_unidade_medida,
       b.nm_fantasia_produto
 
from
   pedido_venda a                    with (nolock) 
   inner join pedido_venda_item b    with (nolock) on a.cd_pedido_venda    = b.cd_pedido_venda
   inner join vendedor cli           with (nolock) on cli.cd_vendedor      = a.cd_vendedor
   left outer join unidade_medida um with (nolock) on um.cd_unidade_medida = b.cd_unidade_medida
where
   cli.cd_vendedor        = @cd_vendedor                        and
   b.cd_categoria_produto = @cd_mapa                            and
   (a.dt_pedido_venda between @dt_inicial and @dt_final)        and
   (b.qt_item_pedido_venda*b.vl_unitario_item_pedido / @vl_moeda) > 0      and
   isnull(a.ic_consignacao_pedido,'N') <> 'S'               and
   IsNull(b.dt_cancelamento_item,@dt_final + 1) > @dt_final and --Desconsidera itens cancelados depois da data final
   IsNull(a.dt_cancelamento_pedido,@dt_final+1) > @dt_final     --Desconsider pedidos de venda cancelados                


order by
   total desc

