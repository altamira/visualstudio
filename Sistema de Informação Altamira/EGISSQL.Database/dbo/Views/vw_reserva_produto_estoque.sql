
CREATE VIEW vw_reserva_produto_estoque
------------------------------------------------------------------------------------
--sp_helptext vw_reserva_produto_estoque
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2008
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Reserva de produtos no Estoque
--Banco de Dados	: EGISSQL 
--Objetivo	        : Mostra a Reserva de Produtos no Estoque
--Data                  : 06.11.2008
--Atualização           : 22.02.2009 - Complemento dos campos - Carlos Fernandes
--17.03.2009 - Ajuste Diversos - Carlos Fernandes
--07.04.2009 - Ajuste da Consulta para mostrar RI/Contrados - Carlos Fernandes
--08.04.2009 - Somente os Pedidos sem Atendimento - Carlos Fernandes
--13.04.2009 - Ajuste na View - Carlos Fernandes
--22.07.2009 - Ajustes diversos disponível - Carlos/Luis
------------------------------------------------------------------------------------
as
 
--select * from movimento_estoque

select
  me.cd_movimento_estoque,
  me.dt_movimento_estoque,
  me.cd_documento_movimento,
  me.cd_item_documento,
  me.qt_movimento_estoque,
  me.nm_historico_movimento,
  me.cd_produto,
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  me.cd_fase_produto,
  fp.nm_fase_produto,
  c.nm_fantasia_cliente    as nm_destinatario,
  --me.nm_destinatario,

  case when pvi.dt_entrega_vendas_pedido is null then
    me.dt_documento_movimento
  else
    pvi.dt_entrega_vendas_pedido
  end                                            as dt_entrega_vendas_pedido,

  pvi.vl_unitario_item_pedido,

  ve.nm_fantasia_vendedor                        as nm_vendedor_externo,
  vi.nm_fantasia_vendedor                        as nm_vendedor_interno,

  case when isnull(pvi.qt_saldo_pedido_venda,0)>0 then
    pvi.qt_saldo_pedido_venda
  else
    me.qt_movimento_estoque 
  end                                            as qt_saldo_pedido_venda,

  pvi.qt_item_pedido_venda,
  pv.cd_pedido_venda,
  pvi.cd_item_pedido_venda,
  pv.cd_cliente,
  pv.cd_vendedor,
  pv.cd_vendedor_interno,
  pvi.dt_cancelamento_item

from
  movimento_estoque me                  with (nolock)
  inner join produto p                  with (nolock) on p.cd_produto             = me.cd_produto
  inner join fase_produto fp            with (nolock) on fp.cd_fase_produto       = me.cd_fase_produto
  left outer join pedido_venda pv       with (nolock) on pv.cd_pedido_venda       = me.cd_documento_movimento


  left outer join pedido_venda_Item pvi with (nolock) on pvi.cd_pedido_venda      = pv.cd_pedido_venda   and
                                                         pvi.cd_item_pedido_venda = me.cd_item_documento 


  left outer join cliente c             with (nolock) on c.cd_cliente             = pv.cd_cliente 
  left outer join Vendedor ve           with (nolock) on ve.cd_vendedor           = pv.cd_vendedor
  left outer join Vendedor vi           with (nolock) on vi.cd_vendedor           = pv.cd_vendedor_interno

where
  isnull(me.cd_tipo_movimento_estoque,0) = 2  and
  isnull(pvi.qt_saldo_pedido_venda,0)>0       and     --Somente os Pedidos de Venda em Aberto
  pvi.dt_cancelamento_item  is null                   --Somente os Pedidos em Aberto - que não foram cancelados
  
  --Saída/Reserva
  

