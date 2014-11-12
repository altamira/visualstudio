
CREATE procedure sp_InsereDepartamento
@cd_departamento int output,
@nm_departamento varchar (40) output,
@sg_departamento char (10) output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  -- gerar codigo e executa travamento
  SELECT @cd_departamento = ISNULL(MAX(cd_departamento),0) + 1 FROM Departamento TABLOCK
  INSERT INTO Departamento( cd_departamento,nm_departamento,sg_departamento)
     VALUES (@cd_departamento,@nm_departamento,@sg_departamento)
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

