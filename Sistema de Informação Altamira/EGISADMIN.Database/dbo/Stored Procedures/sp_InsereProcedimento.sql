
CREATE procedure sp_InsereProcedimento
@cd_procedimento int output,
@nm_procedimento varchar (40) output,
@ds_procedimento text output,
@dt_criacao_procedimento datetime output,
@dt_alteracao_procedimento datetime output,
@cd_usuario int output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  -- gerar codigo e executa travamento
  SELECT @cd_procedimento = ISNULL(MAX(cd_procedimento),0) + 1 FROM Procedimento TABLOCK
  INSERT INTO Procedimento( cd_procedimento,nm_procedimento,ds_procedimento,dt_criacao_procedimento,dt_alteracao_procedimento,cd_usuario)
     VALUES (@cd_procedimento,@nm_procedimento,@ds_procedimento,@dt_criacao_procedimento,@dt_alteracao_procedimento,@cd_usuario)
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

