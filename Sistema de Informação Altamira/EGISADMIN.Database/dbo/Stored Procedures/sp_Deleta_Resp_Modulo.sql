
CREATE PROCEDURE [sp_Deleta_Resp_Modulo]
@cd_usuario int,
@cd_modulo int
AS
  Delete from Modulo_Responsavel
   where cd_usuario = @cd_usuario
     and cd_modulo  = @cd_modulo

