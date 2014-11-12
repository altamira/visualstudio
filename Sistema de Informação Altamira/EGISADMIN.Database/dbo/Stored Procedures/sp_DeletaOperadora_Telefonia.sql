
CREATE procedure sp_DeletaOperadora_Telefonia
@cd_operadora int output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM Operadora_Telefonia
     WHERE
         cd_operadora = @cd_operadora
 
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

