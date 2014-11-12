

CREATE PROCEDURE sp_RegistraLog
@cd_usuario int,
@cd_menu int,
@cd_modulo int,
@sg_log_acesso SmallInt
 AS
  INSERT INTO LogAcesso (dt_log_acesso, cd_usuario, cd_menu, cd_modulo, sg_log_acesso)
        VALUES (getdate(), @cd_usuario, @cd_menu, @cd_modulo, @sg_log_acesso)



