
create procedure sp_InsereUsuario_Empresa
@cd_usuario int output,
@cd_empresa int output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  INSERT INTO Usuario_Empresa( cd_usuario,cd_empresa)
     VALUES (@cd_usuario,@cd_empresa)
  Select 
         @cd_usuario = cd_usuario,
         @cd_empresa = cd_empresa
  From Usuario_Empresa
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

