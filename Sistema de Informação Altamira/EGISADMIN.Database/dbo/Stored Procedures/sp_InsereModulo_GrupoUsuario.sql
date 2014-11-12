
CREATE PROCEDURE [sp_InsereModulo_GrupoUsuario]
@cd_grupo_usuario int,
@cd_modulo int
AS
  Insert into Modulo_GrupoUsuario (cd_grupo_usuario, cd_modulo)
       values (@cd_grupo_usuario,@cd_modulo)

