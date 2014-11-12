
CREATE PROCEDURE [sp_View_UsuarioModulo]
@cd_modulo int
AS
SELECT DISTINCT Usuario.nm_fantasia_usuario
FROM Usuario INNER JOIN
   Usuario_GrupoUsuario ON 
   Usuario.cd_usuario = Usuario_GrupoUsuario.cd_usuario INNER JOIN
   Modulo_GrupoUsuario ON 
   Usuario_GrupoUsuario.cd_grupo_usuario = Modulo_GrupoUsuario.cd_grupo_usuario
WHERE Modulo_GrupoUsuario.cd_modulo = @cd_modulo
ORDER BY nm_fantasia_usuario

