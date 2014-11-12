
create procedure sp_DeletaMensagem
@cd_mensagem int output,
@nm_mensagem varchar (40) output,
@ds_mensagem text output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM Mensagem
     WHERE
         cd_mensagem = @cd_mensagem and 
         nm_mensagem = @nm_mensagem
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

