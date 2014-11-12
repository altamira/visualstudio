

/****** Object:  Stored Procedure dbo.pr_consulta_coleta_Loja_Regiao    Script Date: 13/12/2002 15:08:18 ******/


CREATE    PROCEDURE pr_consulta_coleta_Loja_Regiao
/*---------------------------------------------------------------------------  
  procedure      : pr_consulta_coleta_Loja_Regiao
  Autor(es)      : Adriano Levy  
  Banco de dados : EgisSql
  Objetivo       : Retornar as coletas processadas por lija e regiao dentro de um 
                   determinado período
  Data           : 28/05/2002
---------------------------------------------------------------------------  */
@ic_parametro  char(1),
@dt_inicial    datetime,
@dt_final      datetime
as
Select dbo.cliente.nm_fantasia_cliente as 'Cliente',
       dbo.Loja_Coleta.nm_loja_coleta as 'Loja',
       dbo.regiao_coleta.nm_regiao_coleta as 'Região', 
       dbo.coleta_item.cd_coleta as 'No. Coleta',
       convert(char(10),dbo.coleta.dt_coleta,103) as 'Data',
       dbo.coleta_item.cd_item_coleta as 'Item',
       isnull(dbo.Produto.nm_produto,'') as 'Produto',
       isnull(dbo.coleta_produto_concorrente.nm_coleta_prd_concorrente,'') as 'Prd.Concorrente',
       isnull(cast(dbo.Coleta_Item.qt_duzia_item_coleta as numeric(25,2)),0) as 'Dúzia',
       isnull(cast(dbo.Coleta_Item.qt_item_coleta as integer),0) as 'Qtde.',
       isnull(cast(dbo.Coleta_Item.qt_frente_item_coleta as integer),0) as 'Frente',
       isnull(cast(dbo.Coleta_Item.vl_item_coleta as numeric(25,2)),0) as 'Preço',
       isnull(dbo.Coleta_Item.cd_status_coleta,'') as 'Status',
       dbo.rede_loja.nm_rede_loja as 'Rede',
       dbo.bandeira_loja.nm_bandeira_loja as 'Bandeira',
       dbo.Cidade.nm_cidade as 'Cidade',
       dbo.Estado.sg_estado as 'Estado',
       dbo.grupo_categoria.nm_grupo_categoria as 'Grupo',
       dbo.categoria_produto.nm_categoria_produto as 'Categoria'

from dbo.coleta_item left join dbo.produto on dbo.Coleta_Item.cd_produto=dbo.produto.cd_produto
                     left join dbo.categoria_produto on dbo.produto.cd_categoria_produto=dbo.categoria_produto.cd_categoria_produto 
                     left join dbo.grupo_categoria on dbo.categoria_produto.cd_grupo_categoria=dbo.grupo_categoria.cd_grupo_categoria 
                     left join dbo.Coleta_Produto_Concorrente on dbo.Coleta_Item.cd_produto_concorrente=dbo.coleta_produto_concorrente.cd_coleta_prd_concorrente 
                     left join dbo.Coleta on dbo.Coleta_Item.cd_coleta=dbo.coleta.cd_coleta 
                     left join dbo.Cliente on dbo.Coleta.cd_cliente=dbo.cliente.cd_cliente 
                     left join dbo.Loja_Coleta on dbo.Coleta.cd_loja_coleta=dbo.Loja_coleta.cd_loja_coleta
                     left join dbo.regiao_coleta on dbo.Coleta.cd_regiao_coleta=dbo.regiao_coleta.cd_regiao_coleta
                     left join dbo.bandeira_loja on dbo.loja_Coleta.cd_bandeira_loja=dbo.bandeira_loja.cd_bandeira_loja
                     left join dbo.rede_loja on dbo.bandeira_loja.cd_rede_loja=dbo.rede_loja.cd_rede_loja
		     left join dbo.Cidade on dbo.regiao_coleta.cd_cidade=dbo.Cidade.cd_cidade
		     left join dbo.estado on dbo.regiao_coleta.cd_estado=dbo.estado.cd_estado
where dbo.Coleta.dt_coleta between @dt_inicial and @dt_final 
order by dbo.coleta_item.cd_coleta,
         dbo.coleta_item.cd_item_coleta









