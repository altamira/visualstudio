
create procedure sp_DeletaDepartamento_Usuario
@cd_departamento int output,
@cd_usuario int output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM Departamento_Usuario
     WHERE
         cd_departamento = @cd_departamento and 
         cd_usuario = @cd_usuario
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

