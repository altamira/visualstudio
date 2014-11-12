
create procedure pr_valorpedido_valorinvoice_fornecedor

@dt_inicial DateTime,
@dt_final   DateTime,
@cd_moeda   int = 0
as

 --converte valores do pedido para moeda
 select pi.cd_pedido_importacao,
		IsNull(sum(pii.qt_item_ped_imp* pii.vl_item_ped_imp),0)* dbo.fn_vl_moeda_periodo(pi.cd_moeda,pi.dt_pedido_importacao) / 
        dbo.fn_vl_moeda_periodo(@cd_moeda,pi.dt_pedido_importacao) as ValorPedido

 into #CotacaoPedido
 from pedido_importacao pi
      left outer join pedido_importacao_item pii on pii.cd_pedido_importacao=pi.cd_pedido_importacao
 where pi.dt_pedido_importacao between @dt_inicial and @dt_final
   and IsNull(pii.dt_cancel_item_ped_imp,0)=0
 group by pi.cd_pedido_importacao,pi.dt_pedido_importacao,pi.cd_moeda

 --seleciona valores do pedido
 select f.nm_fantasia_fornecedor as Fornecedor,
         year(pi.dt_pedido_importacao) as Ano,
	 month(pi.dt_pedido_importacao) as Mes,
         sum(co.ValorPedido) as ValorPedido,	   
         Cast(0 as Float) as ValorInvoice
 into #ValoresPedido
 from pedido_importacao pi
	left outer join fornecedor f on f.cd_fornecedor=pi.cd_fornecedor
        left outer join #CotacaoPedido co on co.cd_pedido_importacao=pi.cd_pedido_importacao
 where pi.dt_pedido_importacao between @dt_inicial and @dt_final
 group by f.nm_fantasia_fornecedor, year(pi.dt_pedido_importacao), month(pi.dt_pedido_importacao)
 order by f.nm_fantasia_fornecedor, year(pi.dt_pedido_importacao), month(pi.dt_pedido_importacao)

 --converte valores da invoice para moeda
 select i.cd_invoice,
       i.vl_total_invoice * dbo.fn_vl_moeda_periodo(i.cd_moeda,i.dt_moeda) / 
       dbo.fn_vl_moeda_periodo(@cd_moeda,i.dt_moeda) as ValorInvoice
 into #CotacaoInvoice
 from invoice i

 --selecioa valores da invoice
 select f.nm_fantasia_fornecedor as Fornecedor,
         year(i.dt_invoice) as Ano,
	 month(i.dt_invoice) as Mes,
	 sum(co.ValorInvoice) as ValorInvoice
 into #ValoresInvoice
 from invoice i
        left outer join fornecedor f on f.cd_fornecedor=i.cd_fornecedor
        left outer join #CotacaoInvoice co on co.cd_invoice=i.cd_invoice
 where i.dt_invoice between @dt_inicial and @dt_final
 group by f.nm_fantasia_fornecedor, year(i.dt_invoice), month(i.dt_invoice)
 order by f.nm_fantasia_fornecedor, year(i.dt_invoice), month(i.dt_invoice)


 --prepara tabela de saida
 update #ValoresPedido 
 set ValorInvoice = ValoresInvoice.ValorInvoice
 from #ValoresPedido,(select ValorInvoice, Fornecedor, Ano, Mes 
                    from #ValoresInvoice) as ValoresInvoice
 where #ValoresPedido.Fornecedor=ValoresInvoice.Fornecedor and
       #ValoresPedido.Ano=ValoresInvoice.Ano and
       #ValoresPedido.Mes=ValoresInvoice.Mes

 select * from #ValoresPedido
              
--------------------------------------------------------------------------
--Testando a Stored Procedure
--------------------------------------------------------------------------
--exec pr_valorpedido_valorinvoice_fornecedor '11/01/2004','01/31/2005',4 --4=Iene
