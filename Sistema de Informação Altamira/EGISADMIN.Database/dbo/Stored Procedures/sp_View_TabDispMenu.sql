
CREATE PROCEDURE [sp_View_TabDispMenu]
@cd_menu int
AS
  SELECT T.cd_tabela, T.nm_tabela
    FROM Tabela T
   WHERE cd_tabela not in (SELECT cd_tabela 
                             FROM Menu_Tabela
                            WHERE cd_menu = @cd_menu)
  ORDER BY nm_tabela 

