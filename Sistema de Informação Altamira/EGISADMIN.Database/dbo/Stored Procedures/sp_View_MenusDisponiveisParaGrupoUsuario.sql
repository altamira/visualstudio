
CREATE PROCEDURE [sp_View_MenusDisponiveisParaGrupoUsuario]
@cd_grupo_usuario int
AS
SELECT M.cd_menu, M.nm_menu
FROM Menu M
WHERE M.cd_menu not in 
    (SELECT cd_menu FROM Menu_GrupoUsuario
     WHERE cd_grupo_usuario = @cd_grupo_usuario)
ORDER BY nm_menu

