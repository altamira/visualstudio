

/****** Object:  Stored Procedure dbo.pr_pedido_entrega_atraso    Script Date: 13/12/2002 15:08:38 ******/


CREATE  procedure pr_pedido_entrega_atraso
@dt_base datetime

as

select 
  ni.cd_nota_saida				as 'NotaFiscal',
  ni.cd_item_nota_saida 			as 'Item',
  n.dt_nota_saida				as 'Emissao',
  cli.nm_fantasia_cliente 			as 'Cliente',
  n.cd_pedido_cliente	 			as 'Pedido',
  ni.vl_unitario_item_nota		 	as 'ValorItem',
  n.ds_obs_compl_nota_saida			as 'Observacao',
  pvi.dt_entrega_vendas_pedido			as 'DtEntrega',
  n.dt_saida_nota_saida				as 'DtSaida',
  v.nm_fantasia_vendedor			as 'VendExterno'

from
  Pedido_Venda_Item pvi,
  Nota_Saida_Item ni,
  Nota_Saida n left outer join
  Cliente cli on cli.cd_cliente = n.cd_cliente left outer join
  Vendedor v on v.cd_vendedor = n.cd_vendedor
Where
   ni.cd_nota_saida = n.cd_nota_saida and
   pvi.cd_pedido_venda = ni.cd_pedido_venda and
   pvi.dt_entrega_vendas_pedido < @dt_base and
   n.dt_saida_nota_saida is null and
   ni.dt_cancel_item_nota_saida is null

order by cli.nm_fantasia_cliente




