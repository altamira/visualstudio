CREATE view vw_lista_de_precos as

select

  gp.cd_grupo_produto
  , gp.nm_grupo_produto
  , p.cd_produto          as 'REGISTRO'
  , p.cd_mascara_produto  as 'CODIGO'
  , p.nm_fantasia_produto as 'FANTASIA' 
  , p.nm_produto          as 'DESCRICAO' 
  , um.sg_unidade_medida  as 'UNIDADE'
  , p.vl_produto          as 'VALOR'
  , MAX( ph.dt_historico_produto ) as 'DATAULTIMOREAJ'

from

  Produto p

  Inner Join Grupo_Produto gp
        on gp.cd_grupo_produto = p.cd_grupo_produto

  Left Outer Join Grupo_Produto_Custo gpc
             on gpc.cd_grupo_produto = gp.cd_grupo_produto

  Left Outer Join Produto_Custo pc
              on pc.cd_produto = p.cd_produto

  Left Outer Join Unidade_Medida um
             on um.cd_unidade_medida = p.cd_unidade_medida

  Left Outer Join Produto_Historico ph
             on ph.cd_produto = p.cd_produto

where

  (( IsNull( gpc.ic_lista_preco, 'N' ) = 'S' ) and
   ( IsNull( gpc.ic_lista_rep_grupo_prod, 'N' ) = 'S' )
   or
   ( IsNull( pc.ic_lista_preco_produto, 'N' ) = 'S' ) and
   ( IsNull( pc.ic_lista_rep_produto, 'N' ) = 'S' ))

group by

  gp.cd_grupo_produto
  , gp.nm_grupo_produto
  , p.cd_produto
  , p.cd_mascara_produto
  , p.nm_fantasia_produto
  , p.nm_produto
  , um.sg_unidade_medida
  , p.vl_produto

--select top 100 * from vw_lista_de_precos
