
create procedure pr_valorpedido_valorinvoice_pais

@dt_inicial DateTime,
@dt_final   DateTime,
@cd_moeda   int = 0
as

 --converte o valor do pedido para a moeda
/* select pi.cd_pedido_importacao,
       pi.vl_pedido_importacao * dbo.fn_vl_moeda_periodo(pi.cd_moeda,pi.dt_pedido_importacao) / 
       dbo.fn_vl_moeda_periodo(@cd_moeda,pi.dt_pedido_importacao) as ValorPedido
 into #CotacaoPedido
 from pedido_importacao pi
 where pi.dt_pedido_importacao between @dt_inicial and @dt_final*/

 select pi.cd_pedido_importacao,
       Sum(((pii.vl_item_ped_imp * pii.qt_item_ped_imp) * dbo.fn_vl_moeda_periodo(pi.cd_moeda,pi.dt_pedido_importacao))) as ValorItem,
       Cast(0 as Float) as ValorPedido,
       pi.dt_pedido_importacao 
 into #CotacaoPedido
 from pedido_importacao_item pii
      left outer join pedido_importacao pi on pi.cd_pedido_importacao = pii.cd_pedido_importacao
 where pii.dt_entrega_ped_imp between @dt_inicial and @dt_final
   and IsNull(pii.dt_cancel_item_ped_imp,0)=0
 group by pi.cd_pedido_importacao, pi.dt_pedido_importacao

 update #CotacaoPedido set ValorPedido = ValorItem / dbo.fn_vl_moeda_periodo(@cd_moeda,dt_pedido_importacao)

 --seleciona os valores do pedido
 select p.nm_pais as Pais, 
         year(pi.dt_pedido_importacao) as Ano,
	 month(pi.dt_pedido_importacao) as Mes,
         sum(co.ValorPedido) as ValorPedido,	   
         Cast(0 as Float) as ValorInvoice
 into #ValoresPedido
 from pedido_importacao pi
	left outer join pais p on p.cd_pais=pi.cd_pais_procedencia
--  left outer join #CotacaoPedido co on co.cd_pedido_importacao=pi.cd_pedido_importacao
  inner join #CotacaoPedido co on co.cd_pedido_importacao=pi.cd_pedido_importacao
 where pi.dt_pedido_importacao between @dt_inicial and @dt_final
 group by p.nm_pais, year(pi.dt_pedido_importacao), month(pi.dt_pedido_importacao)
 order by p.nm_pais, year(pi.dt_pedido_importacao), month(pi.dt_pedido_importacao)

 --converte o valor da invoice para a moeda
 select i.cd_invoice,
       i.vl_total_invoice * dbo.fn_vl_moeda_periodo(i.cd_moeda,i.dt_moeda) / 
       dbo.fn_vl_moeda_periodo(@cd_moeda,i.dt_moeda) as ValorInvoice
 into #CotacaoInvoice
 from invoice i

 --seleciona os valores da invoice
 select p.nm_pais as Pais, 
         year(i.dt_invoice) as Ano,
	 month(i.dt_invoice) as Mes,
	 sum(co.ValorInvoice) as ValorInvoice
 into #ValoresInvoice
 from invoice i
        left outer join fornecedor f on f.cd_fornecedor=i.cd_fornecedor
	left outer join pais p on p.cd_pais=f.cd_pais
        left outer join #CotacaoInvoice co on co.cd_invoice=i.cd_invoice
 where i.dt_invoice between @dt_inicial and @dt_final
 group by p.nm_pais, year(i.dt_invoice), month(i.dt_invoice)
 order by p.nm_pais, year(i.dt_invoice), month(i.dt_invoice)


 --prepara tabela de saida de dados
 update #ValoresPedido 
 set ValorInvoice = ValoresInvoice.ValorInvoice
 from #ValoresPedido,(select ValorInvoice,Pais, Ano, Mes 
                    from #ValoresInvoice) as ValoresInvoice
 where #ValoresPedido.Pais=ValoresInvoice.Pais and
       #ValoresPedido.Ano=ValoresInvoice.Ano and
       #ValoresPedido.Mes=ValoresInvoice.Mes
 
 select * from #ValoresPedido
              
--------------------------------------------------------------------------
--Testando a Stored Procedure
--------------------------------------------------------------------------
--exec pr_valorpedido_valorinvoice_pais '11/01/2004','01/31/2005',4 --4=Iene
