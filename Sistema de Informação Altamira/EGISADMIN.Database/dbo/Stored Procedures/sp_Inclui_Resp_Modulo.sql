
CREATE PROCEDURE [sp_Inclui_Resp_Modulo] 
@cd_usuario int,
@cd_modulo int
AS
  INSERT INTO Modulo_Responsavel (cd_modulo,cd_usuario) values (@cd_modulo,@cd_usuario)

