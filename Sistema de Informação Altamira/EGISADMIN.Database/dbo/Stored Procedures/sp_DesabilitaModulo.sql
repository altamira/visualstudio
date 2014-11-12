
CREATE PROCEDURE [sp_DesabilitaModulo]
@cd_usuario int,
@cd_modulo int
 AS
  DELETE FROM Menu_Usuario
   WHERE  cd_usuario = @cd_usuario
     AND  cd_modulo  = @cd_modulo

