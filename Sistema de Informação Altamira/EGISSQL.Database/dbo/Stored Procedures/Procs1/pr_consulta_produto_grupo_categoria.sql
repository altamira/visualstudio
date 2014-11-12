

/****** Object:  Stored Procedure dbo.pr_consulta_produto_grupo_categoria    Script Date: 13/12/2002 15:08:23 ******/

CREATE PROCEDURE pr_consulta_produto_grupo_categoria

  @cd_grupo_categoria int,
  @cd_categoria_produto int,
  @nm_fantasia_produto varchar(30)

AS

  SELECT
    gc.nm_grupo_categoria, 
    cp.nm_categoria_produto, 
    p.nm_fantasia_produto, 
    p.nm_produto, 
    p.qt_peso_liquido, 
    p.qt_peso_bruto, 
    p.qt_espessura_produto, 
    p.qt_largura_produto, 
    p.qt_comprimento_produto, 
    p.qt_altura_produto, 
    p.ds_produto
  FROM
    Produto p RIGHT OUTER JOIN
    Categoria_Produto cp ON p.cd_categoria_produto = cp.cd_categoria_produto RIGHT OUTER JOIN
    Grupo_Categoria gc ON cp.cd_grupo_categoria = gc.cd_grupo_categoria
  WHERE
    gc.cd_grupo_categoria = @cd_grupo_categoria
  ORDER BY 
    gc.nm_grupo_categoria, 
    cp.nm_categoria_produto, 
    p.nm_fantasia_produto



