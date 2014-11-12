--pr_pedidos_cliente_categoria1
-----------------------------------------------------------------------------------
--GBS-Global Business Solution Ltda.
-----------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio Vanderlei  / Carlos Cardoso Fernandes       
--Consulta de Pedidos por Cliente e Categoria
--Data         : 05.06.2000
--Atualizado   : 05.07.2000 - Lucio (Mudada para Período)
--             : 19.06.2001 - Consistência do campo CONSIG do pedido (Consignação)
--             : 06.04.2002 - Alteração para o padrão do EGIS - Sandro Campos
--             : 03/09/2002 - Alterado Parâmetro para Filtrar por Código do Cliente - Daniel C. Neto
-- 06/11/2003 - Inclusão de Moeda. - Daniel C. Neto.
-- 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar
--            - Daniel C. Neto.
-- 11.03.2006 - Nome Fantasia do Cliente - Carlos Fernandes
-- 03.03.2010 - Ajuste dos Pedidos com Cliente origem - Carlos Fernandes/Junior
--------------------------------------------------------------------------------------

create procedure pr_pedidos_cliente_categoria1
@cd_cliente int,
@cd_mapa    varchar(10),
@dt_inicial datetime,
@dt_final   datetime,
@cd_moeda   int = 1
as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


select a.cd_pedido_venda, 
       a.dt_pedido_venda, 
       b.cd_item_pedido_venda, 
       b.qt_item_pedido_venda, 
       b.nm_produto_pedido,
       b.qt_item_pedido_venda*b.vl_unitario_item_pedido / @vl_moeda as 'total',
       b.dt_entrega_fabrica_pedido,
       b.qt_saldo_pedido_venda,
       cli.nm_fantasia_cliente

from
   pedido_venda a                    with (nolock) 
   inner join pedido_venda_item b    with (nolock) on a.cd_pedido_venda    = b.cd_pedido_venda 
   inner join Cliente cli            with (nolock) on cli.cd_cliente       = a.cd_cliente
   left outer join Cliente_Origem co with (nolock) ON co.cd_cliente        = a.cd_cliente and
                                                      co.cd_cliente_origem = a.cd_cliente_origem

where
   cli.cd_cliente         = @cd_cliente       and
   b.cd_categoria_produto = @cd_mapa  and
   (a.dt_pedido_venda between @dt_inicial and @dt_final)        and
   (b.qt_item_pedido_venda*b.vl_unitario_item_pedido / @vl_moeda) > 0      and
   isnull(a.ic_consignacao_pedido,'N') <> 'S'            and
   IsNull(b.dt_cancelamento_item,@dt_final + 1) > @dt_final and --Desconsidera itens cancelados depois da data final
   IsNull(a.dt_cancelamento_pedido,@dt_final+1) > @dt_final --Desconsider pedidos de venda cancelados                
   and
   (isnull(a.cd_cliente_origem,0)=0 or cli.cd_cliente <> co.cd_cliente )      

order by total desc
