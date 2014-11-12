

CREATE PROCEDURE pr_consulta_serie_composicao

@sg_serie_produto char(10),
@cd_sub_serie int,
@cd_tipo_serie_produto int

as

Select
  a.cd_serie_produto      as 'CodSerie',
  a.sg_serie_produto      as 'Serie',
  b.cd_serie_produto      as 'CodSeriePai',
  b.cd_sub_serie          as 'CodSubSerie',
  b.cd_item_sub_serie     as 'Item',
  b.cd_tipo_serie_produto as 'CodTipoSerie',
  b.qt_sub_serie          as 'Qtde',
  b.qt_montagem_sub_serie as 'QtdeMontagem',
  b.cd_produto            as 'CodProduto',
  c.sg_tipo_serie_produto as 'TipoSerie',
  d.nm_tipo_montagem      as 'TipoMontagem',
  e.nm_fantasia_produto   as 'Produto',
  b.cd_montagem           as 'Montagem',
  b.ic_montagem_g_sub_serie as 'MontagemG',
  b.qt_espessura          as 'Espessura',
  b.cd_usuario            as 'Usuario',
  b.dt_usuario            as 'Alteracao'

from
  Serie_Produto a

Left Join Sub_Serie_Produto b
On a.cd_serie_produto = b.cd_serie_produto

Left Join Tipo_Serie_Produto c
On b.cd_tipo_serie_produto = c.cd_tipo_serie_produto

Left Join Tipo_Montagem d
On b.cd_tipo_montagem = d.cd_tipo_montagem

Left Join Produto e
On b.cd_produto = e.cd_produto

where (@sg_serie_produto = '0' or
       a.sg_serie_produto = @sg_serie_produto) and
       b.cd_sub_serie     = @cd_sub_serie      and
       b.cd_tipo_serie_produto = @cd_tipo_serie_produto

order by b.cd_sub_serie,
         isnull(b.cd_ordem_sub_serie_prod,999)

