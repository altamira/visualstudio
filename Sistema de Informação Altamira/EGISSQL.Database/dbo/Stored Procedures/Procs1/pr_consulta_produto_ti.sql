
CREATE PROCEDURE pr_consulta_produto_ti

@ic_parametro 	     int,
@nm_fantasia_produto varchar(20)

AS
-------------------------------------------------------------------------------------------
  if @ic_parametro = '1' --Consulta Todos Produtos
-------------------------------------------------------------------------------------------
  begin
    
    Select
      a.cd_grupo_produto, 
      a.cd_produto,
      a.nm_produto,
      a.nm_fantasia_produto, 
      a.qt_peso_bruto   as 'PesoBruto',
      a.qt_peso_liquido as 'PesoLiquido',
      a.vl_produto,
      b.sg_unidade_medida,
      c.nm_grupo_produto
    from
      Produto a
    Left Join Unidade_Medida b 
    On a.cd_unidade_medida = b.cd_unidade_medida
    Left Join Grupo_Produto c
    On a.cd_grupo_produto = c.cd_grupo_produto
    order by a.nm_fantasia_produto
  end
-------------------------------------------------------------------------------------------
  else if @ic_parametro = '2' --Consulta Somente 1 Produto
-------------------------------------------------------------------------------------------
  begin
    Select
      a.cd_grupo_produto, 
      a.cd_produto,
      a.nm_produto,
      a.nm_fantasia_produto, 
      a.qt_peso_bruto   as 'PesoBruto',
      a.qt_peso_liquido as 'PesoLiquido',
      a.vl_produto,
      b.sg_unidade_medida,
      c.nm_grupo_produto
    from
      Produto a
    Left Join Unidade_Medida b 
    On a.cd_unidade_medida = b.cd_unidade_medida
    Left Join Grupo_Produto c
    On a.cd_grupo_produto = c.cd_grupo_produto
    where 
      a.nm_fantasia_produto like @nm_fantasia_produto + '%'
    order by a.nm_fantasia_produto 
  end

