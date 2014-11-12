
CREATE procedure sp_InsereRelatorio
@cd_relatorio int output,
@nm_relatorio varchar (40) output,
@sg_relatorio char (10) output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  -- gerar codigo e executa travamento
  SELECT @cd_relatorio = ISNULL(MAX(cd_relatorio),0) + 1 FROM Relatorio TABLOCK
  INSERT INTO Relatorio( cd_relatorio,nm_relatorio,sg_relatorio)
     VALUES (@cd_relatorio,@nm_relatorio,@sg_relatorio)
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

