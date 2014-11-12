
create procedure sp_AlteraMensagem
--dados depois da execuçao (novos)
@cd_mensagem int,
@nm_mensagem varchar (40),
@ds_mensagem text,
--dados antes da execuçao (antigos)
@cd_mensagem_old int,
@nm_mensagem_old varchar (40),
@ds_mensagem_old text
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE Mensagem SET          cd_mensagem = @cd_mensagem,
         nm_mensagem = @nm_mensagem,
         ds_mensagem = @ds_mensagem
     WHERE
         cd_mensagem = @cd_mensagem_old and 
         nm_mensagem = @nm_mensagem_old
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

