
CREATE procedure sp_DeletaItemGerencial
@cd_Item_Gerencial int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  DELETE FROM Item_Gerencial
     WHERE
         cd_Item_Gerencial = @cd_Item_Gerencial
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

