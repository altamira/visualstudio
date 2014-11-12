
create procedure sp_InsereMensagem
@cd_mensagem int output,
@nm_mensagem varchar (40) output,
@ds_mensagem text output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  INSERT INTO Mensagem( cd_mensagem,nm_mensagem,ds_mensagem)
     VALUES (@cd_mensagem,@nm_mensagem,@ds_mensagem)
  Select 
         @cd_mensagem = cd_mensagem,
         @nm_mensagem = nm_mensagem
  From Mensagem
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

