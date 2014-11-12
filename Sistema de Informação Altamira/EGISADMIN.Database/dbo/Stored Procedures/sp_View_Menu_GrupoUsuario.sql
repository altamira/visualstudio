
-- Lista os menus disponíveis para um grupo de usuários
CREATE PROCEDURE [sp_View_Menu_GrupoUsuario]
@cd_grupo_usuario int
AS
   SELECT Menu.nm_menu, 
                     Menu.cd_menu, 
                     GrupoUsuario.nm_grupo_usuario, 
                     GrupoUsuario.cd_grupo_usuario, 
                     NivelAcesso.nm_nivel_acesso,
                     NivelAcesso.cd_nivel_acesso
       FROM Menu_GrupoUsuario 
      INNER JOIN  GrupoUsuario 
             ON Menu_GrupoUsuario.cd_grupo_usuario = GrupoUsuario.cd_grupo_usuario
          AND Menu_GrupoUsuario.cd_grupo_usuario = GrupoUsuario.cd_grupo_usuario
     INNER JOIN NivelAcesso 
             ON Menu_GrupoUsuario.cd_nivel_acesso = NivelAcesso.cd_nivel_acesso
     INNER JOIN Menu 
             ON Menu_GrupoUsuario.cd_menu = Menu.cd_nivel_acesso
   WHERE Menu_GrupoUsuario.cd_grupo_usuario = @cd_grupo_usuario

