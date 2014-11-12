
create procedure pr_itenspedido_itensinvoice_pais

@dt_inicial DateTime,
@dt_final DateTime

as

 select p.nm_pais as Pais, 
         year(pi.dt_pedido_importacao) as Ano,
	 month(pi.dt_pedido_importacao) as Mes,
	 count(pi.cd_pedido_importacao) as ItensPedido,
         0 as ItensInvoice
 into #ItensPedido
 from pedido_importacao_item pii
	left outer join pedido_importacao pi on pii.cd_pedido_importacao=pi.cd_pedido_importacao
	left outer join pais p on p.cd_pais=pi.cd_pais_procedencia
 where pi.dt_pedido_importacao between @dt_inicial and @dt_final
   and IsNull(pii.dt_cancel_item_ped_imp,0)=0
 group by p.nm_pais, year(pi.dt_pedido_importacao), month(pi.dt_pedido_importacao)
 order by p.nm_pais, year(pi.dt_pedido_importacao), month(pi.dt_pedido_importacao)


 select p.nm_pais as Pais, 
         year(i.dt_invoice) as Ano,
	 month(i.dt_invoice) as Mes,
	 count(ii.cd_invoice_item) as ItensInvoice
 into #ItensInvoice
 from invoice_item ii
	left outer join invoice i on ii.cd_invoice=i.cd_invoice
        left outer join fornecedor f on f.cd_fornecedor=i.cd_fornecedor
	left outer join pais p on p.cd_pais=f.cd_pais
 where i.dt_invoice between @dt_inicial and @dt_final
 group by p.nm_pais, year(i.dt_invoice), month(i.dt_invoice)
 order by p.nm_pais, year(i.dt_invoice), month(i.dt_invoice)

 select
    isnull(p.Pais,i.Pais) as Pais,
    isnull(p.Ano,i.Ano)   as Ano,
    isnull(p.Mes,i.Mes)   as Mes,
    isnull(p.ItensPedido,0) as ItensPedido,
    isnull(i.ItensInvoice,0) as ItensInvoice
 from 
   #ItensPedido  p full outer join
   #ItensInvoice i on p.Pais = i.Pais and
                      p.Ano  = i.Ano and
                      p.Mes  = i.Mes
 order by
   1,2,3    
              
--------------------------------------------------------------------------
--Testando a Stored Procedure
--------------------------------------------------------------------------
--exec pr_itenspedido_itensinvoice_pais '11/01/2004','01/31/2005'
