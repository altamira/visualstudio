
CREATE procedure sp_InsereHelp
@cd_help int output,
@nm_help varchar (40) output,
@ds_help text output,
@cd_imagem int output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  -- gerar codigo e executa travamento
  SELECT @cd_help = ISNULL(MAX(cd_help),0) + 1 FROM Help TABLOCK
  INSERT INTO Help( cd_help,nm_help,ds_help,cd_imagem)
     VALUES (@cd_help,@nm_help,@ds_help,@cd_imagem)
  Select 
         @cd_help = cd_help,
         @cd_imagem = cd_imagem
  From Help
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

