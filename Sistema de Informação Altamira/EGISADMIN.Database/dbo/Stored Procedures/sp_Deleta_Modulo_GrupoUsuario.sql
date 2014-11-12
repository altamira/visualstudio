
CREATE PROCEDURE [sp_Deleta_Modulo_GrupoUsuario]
@cd_grupo_usuario int
AS
  Delete from Modulo_GrupoUsuario 
   Where cd_grupo_usuario = @cd_grupo_usuario

