
CREATE procedure sp_DeletaHelp
@cd_help int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM Help
     WHERE
         cd_help = @cd_help 
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

