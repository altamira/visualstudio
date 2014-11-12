
CREATE PROCEDURE [sp_ViewUsuario_GrupoUsuario] 
@cd_usuario int
AS
SELECT GU.cd_grupo_usuario, 
       GU.nm_grupo_usuario, 
       UGU.cd_usuario
FROM  Usuario_GrupoUsuario UGU, GrupoUsuario GU
WHERE GU.cd_grupo_usuario *= UGU.cd_grupo_usuario
and UGU.cd_usuario = @cd_usuario
ORDER BY GU.nm_grupo_usuario

