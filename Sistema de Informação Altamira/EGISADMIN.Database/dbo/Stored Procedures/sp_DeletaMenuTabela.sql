
CREATE PROCEDURE [sp_DeletaMenuTabela]
@cd_tabela int,
@cd_menu int
AS
 DELETE FROM Menu_Tabela 
      WHERE cd_menu    = @cd_menu AND
            cd_tabela  = @cd_Tabela

