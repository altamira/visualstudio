
CREATE PROCEDURE pr_consulta_inventario
  @ic_parametro           int,
  @cd_inventario          int,
  @dt_inicial             datetime,
  @dt_final		  datetime

AS

---------------------------------------------
if @ic_parametro = 1 -- Consulta O Inventário
----------------------------------------------
begin

SELECT     Inventario.cd_inventario AS Codigo, Inventario.dt_base_inventario AS [Data Base], Tipo_Inventario.nm_tipo_inventario AS Tipo, 
                      Inventario.vl_total_inventario AS [Total Produto], Inventario.qt_tot_produto_inventario AS [Valor Inventario], 
                      Inventario.nm_obs_inventario AS Observacao, EGISADMin.dbo.Usuario.nm_fantasia_usuario AS Usuario
FROM         Inventario Left outer join
             Tipo_Inventario ON Inventario.cd_tipo_inventario = Tipo_Inventario.cd_tipo_inventario Left outer join
             EGISAdmin.dbo.Usuario ON Inventario.cd_usuario = EGISAdmin.dbo.Usuario.cd_usuario
where
  Inventario.dt_base_inventario between @dt_inicial and @dt_final and
  ( Inventario.cd_inventario = @cd_inventario or @cd_inventario = 0 )
	
Order by
   Inventario.dt_base_inventario desc, Inventario.cd_inventario desc

end

--------------------------------------------------------
if @ic_parametro = 2 -- Consulta Os Itens do Inventario -- A implantar
--------------------------------------------------------
begin

SELECT       ic.cd_item_inventario AS Item, 
             ic.cd_controle_inventario AS Cod_Controle, 
             ic.nm_produto_inventario AS Produto, 
             ic.qt_item_inventario AS Qtd, 
             p.nm_produto AS Descricao, 
             um.sg_unidade_medida AS UN
FROM         Inventario_Composicao ic INNER JOIN
             Produto p ON ic.cd_produto = p.cd_produto INNER JOIN
             Unidade_Medida um ON ic.cd_unidade_medida = um.cd_unidade_medida
where
  ic.cd_inventario = @cd_inventario
	
Order by
   ic.cd_inventario

end



