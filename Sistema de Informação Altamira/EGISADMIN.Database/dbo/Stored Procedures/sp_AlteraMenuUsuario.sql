
CREATE PROCEDURE [sp_AlteraMenuUsuario]
@cd_menu int,
@cd_modulo int,
@cd_usuario int,
@cd_nivel_acesso int
 AS
   UPDATE Menu_Usuario  SET
                      cd_nivel_acesso = @cd_nivel_acesso
     WHERE cd_menu = @cd_menu
             AND cd_modulo = @cd_modulo
             AND cd_usuario = @cd_usuario
        
                      

