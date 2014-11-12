
CREATE PROCEDURE [sp_Deleta_GrupoUsuario_Modulo]
@cd_modulo int
AS
  Delete from Modulo_GrupoUsuario 
   Where cd_modulo = @cd_modulo

