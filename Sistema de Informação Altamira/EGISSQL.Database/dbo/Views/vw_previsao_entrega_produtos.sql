
create view vw_previsao_entrega_produtos
-------------------------------------------------------------------------------------------
--vw_previsao_entrega_produtos
-------------------------------------------------------------------------------------------
-- GBS - Global Business Solution Ltda                                                 2004
-------------------------------------------------------------------------------------------
-- Stored Procedure      : Microsoft SQL Server 2000
-- Autor(es)             : Paulo Souza
-- Banco de Dados        : EGISSQL
-- Objetivo              : Consulta de previsão de entrega de produtos
-- Data                  : 14/01/2005
-------------------------------------------------------------------------------------------
as

select
      c.nm_fantasia_cliente as 'Cliente',
      IsNull(pvi.cd_pedido_venda,0) as 'PedidoVenda',
      IsNull(pvi.cd_item_pedido_venda,0) as 'ItemPedidoVenda',
      p.cd_produto as 'CodigoProduto', 
      Case 
        When IsNull(pci.nm_fantasia_produto,'') <> '' 
          Then pci.nm_fantasia_produto
        Else p.nm_fantasia_produto
      End as 'Produto',
      Case 
        When IsNull(pci.nm_produto,'') <> '' 
          Then pci.nm_produto
        Else p.nm_produto 
      End as 'NomeProduto',
      IsNull(pvi.qt_saldo_pedido_venda,0) as 'SaldoPedidoVenda',
      IsNull(pci.qt_item_pedido_compra,0) as 'Quantidade',
      pvi.dt_entrega_vendas_pedido as 'DataComercial',
      pci.dt_entrega_item_ped_compr as 'DataPrevisao',
      'PC' as 'Forma',
      IsNull(pc.cd_pedido_compra,0) as 'Documento',
      IsNull(pci.cd_item_pedido_compra,0) as 'ItemDocumento',
      dc.nm_destino_compra as 'Destino',
      Cast(Null as DateTime) as 'DataInvoice',
      Cast(Null as DateTime) as 'DataDI',
      pv.cd_pdcompra_pedido_venda as 'PedidoCliente',
      v.nm_fantasia_vendedor as 'Vendedor'
from pedido_compra_item pci
     inner join pedido_compra pc on (pc.cd_pedido_compra = pci.cd_pedido_compra)
     left outer join pedido_venda_item pvi on (pvi.cd_pedido_venda = pci.cd_pedido_venda and
                                               pvi.cd_item_pedido_venda = pci.cd_item_pedido_venda)
     left outer join pedido_venda pv on (pv.cd_pedido_venda = pvi.cd_pedido_venda)
     left outer join cliente c on (c.cd_cliente = pv.cd_cliente)
     left outer join produto p on (p.cd_produto = pci.cd_produto)
     left outer join destino_compra dc on (dc.cd_destino_compra = pc.cd_destino_compra)
     left outer join vendedor v on (v.cd_vendedor = pv.cd_vendedor)
Where pci.dt_item_canc_ped_compra is null and
      pci.qt_saldo_item_Ped_compra > 0

union  

select
      c.nm_fantasia_cliente as 'Cliente',
      IsNull(pvi.cd_pedido_venda,0) as 'PedidoVenda',
      IsNull(pvi.cd_item_pedido_venda,0) as 'ItemPedidoVenda',
      p.cd_produto as 'CodigoProduto', 
      Case 
        When IsNull(pii.nm_fantasia_produto,'') <> '' 
          Then pii.nm_fantasia_produto
        Else p.nm_fantasia_produto
      End as 'Produto',
      Case 
        When IsNull(pii.nm_produto_pedido,'') <> '' 
          Then pii.nm_produto_pedido
        Else p.nm_produto 
      End as 'NomeProduto',
      IsNull(pvi.qt_saldo_pedido_venda,0) as 'SaldoPedidoVenda',
      IsNull(pii.qt_item_ped_imp,0) as 'Quantidade',
      pvi.dt_entrega_vendas_pedido as 'DataComercial',
      pii.dt_entrega_ped_imp as 'DataPrevisao',
      'PI' as 'Forma',
      IsNull(pi.cd_pedido_importacao,0) as 'Documento',
      IsNull(pii.cd_item_ped_imp,0) as 'ItemDocumento',
      dc.nm_destino_compra as 'Destino',
      (Select Max(i.dt_chegada_empresa_prev)
       from invoice_item ii
            inner join invoice i on (i.cd_invoice = ii.cd_invoice)
       where ii.cd_item_ped_imp = pii.cd_item_ped_imp and
             ii.cd_pedido_importacao = pii.cd_pedido_importacao) as 'DataInvoice',
      (Select Max(di.dt_chegada_fabrica)
       from di_item dii
            inner join di on (di.cd_di = dii.cd_di)
       where dii.cd_item_ped_imp = pii.cd_item_ped_imp and
             dii.cd_pedido_importacao = pii.cd_pedido_importacao) as 'DataDi',
      pv.cd_pdcompra_pedido_venda as 'PedidoCliente',
      v.nm_fantasia_vendedor as 'Vendedor'
from pedido_importacao_item pii
     inner join pedido_importacao pi on (pi.cd_pedido_importacao = pii.cd_pedido_importacao)
     left outer join pedido_venda_item pvi on (pvi.cd_pedido_venda = pii.cd_pedido_venda and
                                               pvi.cd_item_pedido_venda = pii.cd_item_pedido_venda)
     left outer join pedido_venda pv on (pv.cd_pedido_venda = pvi.cd_pedido_venda)
     left outer join cliente c on (c.cd_cliente = pv.cd_cliente)
     left outer join produto p on (p.cd_produto = pii.cd_produto)
     left outer join destino_compra dc on (dc.cd_destino_compra = pi.cd_destino_compra)
     left outer join vendedor v on (v.cd_vendedor = pv.cd_vendedor)
where pii.dt_cancel_item_ped_imp is null and
      pii.qt_saldo_item_ped_imp > 0

union

select 
      c.nm_fantasia_cliente as 'Cliente',
      IsNull(pvi.cd_pedido_venda,0) as 'PedidoVenda',
      IsNull(pvi.cd_item_pedido_venda,0) as 'ItemPedidoVenda',
      p.cd_produto as 'CodigoProduto', 
      p.nm_fantasia_produto as 'Produto',
      p.nm_produto as 'NomeProduto',
      IsNull(pvi.qt_saldo_pedido_venda,0) as 'SaldoPedidoVenda',
      IsNull(pp.qt_planejada_processo,0) as 'Quantidade',
      pvi.dt_entrega_vendas_pedido as 'DataComercial',
      pp.dt_entrega_processo as 'DataPrevisao',
      'OP' as 'Forma',
      pp.cd_processo as 'Documento',
      '' as 'ItemDocumento',
      tp.nm_tipo_processo as 'Destino',
      Cast(Null as DateTime) as 'DataInvoice',
      Cast(Null as DateTime) as 'DataDI',
      pv.cd_pdcompra_pedido_venda as 'PedidoCliente',
      v.nm_fantasia_vendedor as 'Vendedor'
from Processo_Producao pp
     left outer join pedido_venda_item pvi on (pvi.cd_pedido_venda = pp.cd_pedido_venda and
                                               pvi.cd_item_pedido_venda = pp.cd_item_pedido_venda)
     left outer join pedido_venda pv on (pv.cd_pedido_venda = pvi.cd_pedido_venda)
     left outer join cliente c on (c.cd_cliente = pv.cd_cliente)
     left outer join produto p on (p.cd_produto = pp.cd_produto)
     left outer join tipo_processo tp on (tp.cd_tipo_processo = pp.cd_tipo_processo)
     left outer join vendedor v on (v.cd_vendedor = pv.cd_vendedor)
where pp.cd_status_processo not in (5,6) and
      pp.qt_planejada_processo > 0


