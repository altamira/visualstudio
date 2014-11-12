
CREATE PROCEDURE pr_montagem_item_retorno_cotacao
@cd_cotacao int

as
select cotacao_item.*,
       cotacao.dt_cotacao,
       cotacao.ds_cotacao,
       cotacao.cd_fornecedor,
       fornec.nm_fantasia_fornecedor,
       fornec.cd_telefone,
       fornec.cd_fax,
       IsNull(fs.dt_pedido_fornecedor, fornec_prod.dt_pedido_fornecedor) as dt_pedido_fornecedor,
       moeda.nm_moeda,
       cotacao.cd_aplicacao_produto,
       aplicacao_produto.nm_aplicacao_produto,
       dbo.fn_mascara_produto(produto.cd_produto) as cd_mascara_produto,
       IsNull(s.nm_servico,produto.nm_fantasia_produto) as nm_fantasia_produto,
       IsNull(s.nm_servico,produto.nm_produto) as nm_produto,
       aplicacao_produto.cd_destinacao_produto,
       un.sg_unidade_medida, un.ic_fator_conversao, 
       case when ic_fechar_negocio = 'S'	 then 1 else 0 end as ic_fechar_negocio_trat,
       cotacao.cd_opcao_compra,
       oc.nm_opcao_compra

from 
   Cotacao_Item cotacao_item 
   left outer join cotacao cotacao          on cotacao.cd_cotacao = cotacao_item.cd_cotacao 
   left outer join fornecedor fornec        on cotacao.cd_fornecedor = fornec.cd_fornecedor 
   left outer join fornecedor_produto fornec_prod on cotacao.cd_fornecedor = fornec_prod.cd_fornecedor and 
                                                     cotacao_item.cd_produto = fornec_prod.cd_produto 
   left outer join moeda moeda                  on moeda.cd_moeda = cotacao_item.cd_Moeda 
   left outer join aplicacao_produto            on aplicacao_produto.cd_aplicacao_produto = cotacao.cd_aplicacao_produto
   left outer join produto                      on produto.cd_produto = cotacao_item.cd_produto 
   left outer join Unidade_Medida un            on un.cd_unidade_medida = cotacao_item.cd_unidade_medida 
   left outer join Servico s                    on s.cd_servico = cotacao_item.cd_servico 
   left outer join Fornecedor_Servico fs        on fs.cd_fornecedor = cotacao.cd_fornecedor and
                                                   fs.cd_servico = cotacao_item.cd_servico
   left outer join Opcao_Compra oc              on cotacao.cd_opcao_compra = oc.cd_opcao_compra
                                                   
where (cotacao.cd_cotacao = @cd_cotacao) 
order by cd_item_cotacao


