
CREATE procedure sp_DeletaCadeiaValor
@cd_cadeia_valor int output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM Cadeia_Valor
     WHERE
         cd_cadeia_valor = @cd_cadeia_valor 
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON

