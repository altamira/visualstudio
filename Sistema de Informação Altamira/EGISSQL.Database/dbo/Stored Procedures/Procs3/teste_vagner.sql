create procedure teste_vagner
as

	select distinct
	  req.cd_requisicao_compra,
	  req.dt_emissao_req_compra,
	  cast(req.ds_requisicao_Compra as varchar(200)) as 'ds_requisicao_compra',
	  a.sg_aplicacao_produto,
	  u.nm_usuario,
	  d.sg_departamento,
	  cast(0 as int) as ic_selecionado,
	  case when IsNull(req.ic_reprovada_req_compra,'N') = 'S' then 'S' 
	       when IsNull(req.ic_aprovada_req_compra,'N') = 'N' then 'S'
	  else 'N'  end as 'ic_nao_aprovada'          
	from 
	  Requisicao_compra req 
	  inner join Requisicao_compra_item rc on rc.cd_requisicao_compra = req.cd_requisicao_compra
	  inner join tipo_requisicao tr on req.cd_tipo_requisicao = tr.cd_tipo_requisicao
	  inner join EgisAdmin.dbo.Usuario u on u.cd_usuario = req.cd_usuario
	  left outer join EgisAdmin.dbo.Departamento d on d.cd_departamento = req.cd_departamento  
	  left outer join Aplicacao_Produto a on a.cd_aplicacao_produto = req.cd_aplicacao_produto
	  left outer join fornecedor_produto fp on rc.cd_produto = fp.cd_produto
	  left outer join Fornecedor_Servico fs on fs.cd_servico = rc.cd_servico
	  left outer join cotacao_item ci on ci.cd_requisicao_compra = rc.cd_requisicao_compra
				      and ci.cd_item_requisicao_compra = rc.cd_item_requisicao_compra
	            and IsNull(ci.cd_servico,ci.cd_produto) = IsNull(rc.cd_servico,rc.cd_produto)
	  left outer join cotacao c on c.cd_cotacao = ci.cd_cotacao and 
	                               c.cd_fornecedor = IsNull(fs.cd_fornecedor,fp.cd_fornecedor )
	  left outer join pedido_compra_item pci on pci.cd_cotacao = ci.cd_cotacao and
	                                            pci.cd_item_cotacao = ci.cd_item_cotacao
	  left outer join fornecedor_informacao_compra fic on fic.cd_fornecedor = c.cd_fornecedor
	 
	  
	 where
	      ( c.cd_cotacao is null ) and
	      isnull(req.ic_liberado_proc_compra,'N')='S' and IsNull(rc.ic_pedido_item_req_compra,'N') = 'N'
	      and pci.cd_pedido_compra is null
	      and isnull(fic.ic_suspenso_compra,'N') = 'N'	
	
	
	order by 
	  req.cd_requisicao_compra desc         

