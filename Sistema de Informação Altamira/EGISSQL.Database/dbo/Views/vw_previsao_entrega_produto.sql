
create view vw_previsao_entrega_produto
as

select
      c.nm_fantasia_cliente              as 'Cliente',
      IsNull(pvi.cd_pedido_venda,0)      as 'PedidoVenda',
      IsNull(pvi.cd_item_pedido_venda,0) as 'ItemPedidoVenda',
      p.cd_produto                       as 'CodigoProduto', 
      Case 
        When IsNull(pci.nm_fantasia_produto,'') <> '' 
          Then pci.nm_fantasia_produto
        Else p.nm_fantasia_produto
      End                                as 'Produto',
      Case 
        When IsNull(pci.nm_produto,'') <> '' 
          Then pci.nm_produto
        Else p.nm_produto 
      End                                 as 'NomeProduto',
      IsNull(pvi.qt_saldo_pedido_venda,0) as 'SaldoPedidoVenda',
      IsNull(pci.qt_item_pedido_compra,0) as 'Quantidade',
      pvi.dt_entrega_vendas_pedido        as 'DataComercial',
      pci.dt_entrega_item_ped_compr       as 'DataPrevisao',
      'PC'                                as 'Forma',
      IsNull(pc.cd_pedido_compra,0)       as 'Documento',
      IsNull(pci.cd_item_pedido_compra,0) as 'ItemDocumento',
      dc.nm_destino_compra                as 'Destino',
      Cast(Null as DateTime)              as 'DataInvoice',
      Cast(Null as DateTime)              as 'DataDI',
      pv.cd_pdcompra_pedido_venda         as 'PedidoCliente',
      v.nm_fantasia_vendedor              as 'Vendedor',
      Cast(pc.ds_pedido_compra as VarChar(8000)) as 'Observacao',
      ''                                         as Identificacao,
      pc.dt_pedido_compra                        as 'Emissao'
from pedido_compra_item pci with (nolock) 
	     inner join pedido_compra pc   with (nolock) on (pc.cd_pedido_compra = pci.cd_pedido_compra)
     left outer join pedido_venda_item pvi with (nolock) on (pvi.cd_pedido_venda = pci.cd_pedido_venda and
                                                             pvi.cd_item_pedido_venda = pci.cd_item_pedido_venda)
     left outer join pedido_venda pv   with (nolock) on (pv.cd_pedido_venda = pvi.cd_pedido_venda)
     left outer join cliente c         with (nolock) on (c.cd_cliente = pv.cd_cliente)
     inner join produto p              with (nolock) on (p.cd_produto = pci.cd_produto)
     left outer join destino_compra dc with (nolock) on (dc.cd_destino_compra = pc.cd_destino_compra)
     left outer join vendedor v        with (nolock) on (v.cd_vendedor = pv.cd_vendedor)
Where 
     pci.dt_item_canc_ped_compra is null and
     isnull(pci.qt_saldo_item_Ped_compra,0) > 0 and
     IsNull(p.cd_produto,0) <> 0 and 
     isnull(pvi.qt_saldo_pedido_venda,0) > 0

union  

select
      c.nm_fantasia_cliente               as 'Cliente',
      IsNull(pvi.cd_pedido_venda,0)       as 'PedidoVenda',
      IsNull(pvi.cd_item_pedido_venda,0)  as 'ItemPedidoVenda',
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
      Case 
	When chfab.dt_chegada_fabrica is not null
	 Then chfab.dt_chegada_fabrica
	 Else
	    Case
	      When chemp.dt_chegada_empresa_prev is not null
	      Then chemp.dt_chegada_empresa_prev
	      Else pii.dt_entrega_ped_imp 
	    End 
	 End as 'DataPrevisao',

--      pii.dt_entrega_ped_imp as 'DataPrevisao', -- Antes da alteração trazia esta data
      'PI' as 'Forma',
      IsNull(pi.cd_pedido_importacao,0) as 'Documento',
      IsNull(pii.cd_item_ped_imp,0)     as 'ItemDocumento',
      dc.nm_destino_compra              as 'Destino',

--       (Select Max(i.dt_chegada_empresa_prev)
--        from invoice_item ii
--             inner join invoice i on (i.cd_invoice = ii.cd_invoice)
--        where ii.cd_item_ped_imp = pii.cd_item_ped_imp and
--              ii.cd_pedido_importacao = pii.cd_pedido_importacao) as 'DataInvoice',

      chemp.dt_chegada_empresa_prev as 'DataInvoice',

--       (Select Max(di.dt_chegada_fabrica)
--        from di_item dii
--             inner join di on (di.cd_di = dii.cd_di)
--        where dii.cd_item_ped_imp = pii.cd_item_ped_imp and
--              dii.cd_pedido_importacao = pii.cd_pedido_importacao) as 'DataDi',

      chfab.dt_chegada_fabrica as 'DataDi',

      pv.cd_pdcompra_pedido_venda as 'PedidoCliente',
      v.nm_fantasia_vendedor as 'Vendedor',
      ltrim(rtrim(isnull(cast(pi.ds_pedido_importacao as varchar(8000)),'')))+ 
      ltrim(rtrim(isnull(cast(pi.ds_obs_ped_imp as varchar(8000)),''))) +
      ltrim(rtrim(isnull(cast(di.ds_observacao_di as varchar(8000)),''))) as 'Observacao',
      pi.cd_identificacao_pedido                                          as Identificacao,
      pi.dt_pedido_importacao                                             as 'Emissao'
from pedido_importacao_item pii      with (nolock) 
     inner join pedido_importacao pi with (nolock) on (pi.cd_pedido_importacao = pii.cd_pedido_importacao)
     left outer join (select dii.cd_item_ped_imp,
                             dii.cd_pedido_importacao,
                             max(di.dt_chegada_fabrica) as dt_chegada_fabrica
                      from di_item dii with (nolock) 
	              inner join di    with (nolock) on (di.cd_di = dii.cd_di)
                      group by dii.cd_item_ped_imp, dii.cd_pedido_importacao) chfab on chfab.cd_item_ped_imp = pii.cd_item_ped_imp and
                                             	                                       chfab.cd_pedido_importacao = pii.cd_pedido_importacao
     left outer join (select ii.cd_item_ped_imp,
                             ii.cd_pedido_importacao,
                             Max(i.dt_chegada_empresa_prev) as dt_chegada_empresa_prev
                      from invoice_item ii
	              inner join invoice i on (i.cd_invoice = ii.cd_invoice)
                      group by ii.cd_item_ped_imp, ii.cd_pedido_importacao) chemp on chemp.cd_item_ped_imp = pii.cd_item_ped_imp and
                                             	                                     chemp.cd_pedido_importacao = pii.cd_pedido_importacao

     left outer join pedido_venda_item pvi on (pvi.cd_pedido_venda = pii.cd_pedido_venda and
                                               pvi.cd_item_pedido_venda = pii.cd_item_pedido_venda)
     left outer join pedido_venda pv on (pv.cd_pedido_venda = pvi.cd_pedido_venda)
     left outer join cliente c on (c.cd_cliente = pv.cd_cliente)
     inner join produto p on (p.cd_produto = pii.cd_produto)
     left outer join destino_compra dc on (dc.cd_destino_compra = pi.cd_destino_compra)
     left outer join vendedor v on (v.cd_vendedor = pv.cd_vendedor)
     left outer join di_item dii on (pii.cd_pedido_importacao = dii.cd_pedido_importacao and
                                     pii.cd_item_ped_imp = dii.cd_item_ped_imp)
     left outer join di on (dii.cd_di = di.cd_di)
     left outer join nota_saida_item nsi on pii.cd_pedido_importacao = nsi.cd_pedido_importacao
                                        and pii.cd_item_ped_imp = nsi.cd_item_ped_imp
                                        and isnull(nsi.ic_movimento_estoque,'N') = 'N'
where pii.dt_cancel_item_ped_imp is null and
      pii.qt_saldo_item_ped_imp + isnull(nsi.qt_item_nota_saida,0) > 0 and
      IsNull(p.cd_produto,0) <> 0 

union

select 
      c.nm_fantasia_cliente               as 'Cliente',
      IsNull(pvi.cd_pedido_venda,0)       as 'PedidoVenda',
      IsNull(pvi.cd_item_pedido_venda,0)  as 'ItemPedidoVenda',
      p.cd_produto                        as 'CodigoProduto', 
      p.nm_fantasia_produto               as 'Produto',
      p.nm_produto                        as 'NomeProduto',
      IsNull(pvi.qt_saldo_pedido_venda,0) as 'SaldoPedidoVenda',
      IsNull(pp.qt_planejada_processo,0)  as 'Quantidade',
      pvi.dt_entrega_vendas_pedido        as 'DataComercial',
      pp.dt_entrega_processo              as 'DataPrevisao',
      'OP'                                as 'Forma',
      Cast(isnull(pp.cd_processo,0) as VarChar(40)) as 'Documento',
      '' as 'ItemDocumento',
      tp.nm_tipo_processo    as 'Destino',
      Cast(Null as DateTime) as 'DataInvoice',
      Cast(Null as DateTime) as 'DataDI',
      pv.cd_pdcompra_pedido_venda as 'PedidoCliente',
      v.nm_fantasia_vendedor as 'Vendedor',
      Cast(pp.ds_processo_fabrica as VarChar(8000)) as 'Observacao',
      '' as Identificacao,
      pp.dt_processo                                as 'Emissao'
from Processo_Producao pp with (nolock) 
     left outer join pedido_venda_item pvi with (nolock) on (pvi.cd_pedido_venda = pp.cd_pedido_venda and
                                                             pvi.cd_item_pedido_venda = pp.cd_item_pedido_venda)
     left outer join pedido_venda pv  with (nolock) on (pv.cd_pedido_venda = pvi.cd_pedido_venda)
     left outer join cliente c        with (nolock) on (c.cd_cliente = pv.cd_cliente)
     left outer join produto p        with (nolock) on (p.cd_produto = pp.cd_produto)
     left outer join tipo_processo tp with (nolock) on (tp.cd_tipo_processo = pp.cd_tipo_processo)
     left outer join vendedor v       with (nolock) on (v.cd_vendedor = pv.cd_vendedor)
where 
      pp.cd_status_processo not in (5,6) and
      pp.qt_planejada_processo > 0 and
      IsNull(p.cd_produto,0) <> 0 and 
      pvi.qt_saldo_pedido_venda > 0


