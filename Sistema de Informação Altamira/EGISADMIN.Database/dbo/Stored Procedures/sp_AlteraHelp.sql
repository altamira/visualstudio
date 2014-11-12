
CREATE procedure sp_AlteraHelp
--dados depois da execuçao (novos)
@cd_help int,
@nm_help varchar (40),
@ds_help text,
@cd_imagem int,
--dados antes da execuçao (antigos)
@cd_help_old int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE Help SET          
         cd_help   = @cd_help,
         nm_help   = @nm_help,
         ds_help   = @ds_help,
         cd_imagem = @cd_imagem
     WHERE
         cd_help   = @cd_help_old
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

