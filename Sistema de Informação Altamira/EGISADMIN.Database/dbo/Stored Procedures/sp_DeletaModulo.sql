
CREATE procedure sp_DeletaModulo
@cd_modulo int output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM Modulo
     WHERE
         cd_modulo = @cd_modulo
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON

