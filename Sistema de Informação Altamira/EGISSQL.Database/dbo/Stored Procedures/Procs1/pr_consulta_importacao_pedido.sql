
create procedure pr_consulta_importacao_pedido

@cd_pedido_venda int

as
Begin
	select pii.cd_pedido_importacao as 'PedidoImportacao',
         pii.cd_item_ped_imp as 'ItemPedido',
         fa.nm_razao_social as 'Fabricante',
	       po.nm_pais as 'PaisFabricante',
	       f.nm_razao_social as 'Exportador',
	       pp.nm_pais as 'PaisExportador',
	       pii.nm_fantasia_produto as 'Produto',
	       pii.nm_produto_pedido as 'Descricao',
	       pii.qt_item_ped_imp as 'Qtd',
	       IsNull(pii.vl_item_ped_imp,0) as 'FOB_Unit',
	       IsNull(pii.vl_item_ped_imp,0) * IsNull(pii.qt_item_ped_imp,0) as 'FOB_Total',
	       IsNull(ti.pc_frete_tipo_importacao,0) as 'Frete',
	       cf.cd_mascara_classificacao as 'NCM',
	       pii.qt_pesliq_item_ped_imp as 'Peso_Liquido',
	       um.sg_unidade_medida as 'Unidade',
         pii.cd_pedido_venda
	from pedido_importacao pi with (nolock)
	     inner join pedido_importacao_item pii with (nolock) on pii.cd_pedido_importacao = pi.cd_pedido_importacao
	     left outer join fabricante fa with (nolock) on fa.cd_fabricante = pii.cd_fabricante
	     left outer join pais po with (nolock) on po.cd_pais = fa.cd_pais
	     left outer join fornecedor f with (nolock) on f.cd_fornecedor = pi.cd_fornecedor
	     left outer join pais pp with (nolock) on pp.cd_pais = pi.cd_pais_procedencia
	     left outer join tipo_importacao ti with (nolock) on ti.cd_tipo_importacao = pi.cd_tipo_importacao
	     left outer join produto_fiscal pf with (nolock) on pf.cd_produto = pii.cd_produto
	     left outer join classificacao_fiscal cf with (nolock) on cf.cd_classificacao_fiscal = pf.cd_classificacao_fiscal
	     left outer join unidade_medida um with (nolock) on um.cd_unidade_medida = pii.cd_unidade_medida   
	Where Isnull(pii.cd_pedido_importacao,0) = (Case 
	                                              When @cd_pedido_venda <> 0 
    	                                            Then @cd_pedido_venda
  	                                            Else IsNull(pii.cd_pedido_importacao,0)
	                                            End) 
  order by pii.cd_pedido_importacao, pii.cd_item_ped_imp
End

--exec pr_consulta_importacao_pedido 3977




