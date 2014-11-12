
create procedure sp_InsereDepartamento_Usuario
@cd_departamento int output,
@cd_usuario int output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  INSERT INTO Departamento_Usuario( cd_departamento,cd_usuario)
     VALUES (@cd_departamento,@cd_usuario)
  Select 
         @cd_departamento = cd_departamento,
         @cd_usuario = cd_usuario
  From Departamento_Usuario
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

