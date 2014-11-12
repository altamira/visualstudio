
CREATE PROCEDURE [sp_DeletaMenuUsuario]
@cd_usuario int,
@cd_modulo int,
@cd_menu int
 AS
   DELETE FROM Menu_Usuario
                 WHERE cd_usuario  = @cd_usuario
                        AND cd_modulo  = @cd_modulo
                        AND cd_menu      = @cd_menu

