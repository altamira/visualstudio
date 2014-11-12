
create procedure sp_DeletaUsuario_Empresa
@cd_usuario int output,
@cd_empresa int output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM Usuario_Empresa
     WHERE
         cd_usuario = @cd_usuario and 
         cd_empresa = @cd_empresa
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

