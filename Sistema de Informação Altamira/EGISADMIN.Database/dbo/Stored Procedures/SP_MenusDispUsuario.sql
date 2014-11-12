
CREATE PROCEDURE [SP_MenusDispUsuario]
@cd_usuario int
AS
SELECT DISTINCT Modulo.nm_modulo,Modulo.cd_modulo, Menu.cd_menu, Menu.nm_menu
  FROM Usuario 
 INNER JOIN Usuario_GrupoUsuario 
    ON Usuario.cd_usuario = Usuario_GrupoUsuario.cd_usuario 
 INNER JOIN Modulo_GrupoUsuario 
    ON Usuario_GrupoUsuario.cd_grupo_usuario = Modulo_GrupoUsuario.cd_grupo_usuario
 INNER JOIN Modulo_Funcao_Menu 
    ON Modulo_GrupoUsuario.cd_modulo = Modulo_Funcao_Menu.cd_modulo
 INNER JOIN Modulo 
    ON Modulo_GrupoUsuario.cd_modulo = Modulo.cd_modulo 
 INNER JOIN Menu 
    ON Modulo_Funcao_Menu.cd_menu = Menu.cd_menu
 WHERE Usuario.cd_usuario = @cd_usuario
   AND Menu.cd_menu not in (SELECT cd_menu 
                              FROM Menu_Usuario
                             WHERE cd_usuario = @cd_usuario)
ORDER BY Modulo.nm_modulo,Menu.nm_menu

