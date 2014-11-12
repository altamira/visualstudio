
CREATE PROCEDURE [sp_view_Estado]
@cd_pais int
AS
  select cd_estado, nm_estado
  from estado 
  where cd_pais = @cd_pais

