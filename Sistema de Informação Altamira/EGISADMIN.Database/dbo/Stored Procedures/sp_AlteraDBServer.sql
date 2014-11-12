
CREATE procedure sp_AlteraDBServer
--dados depois da execuçao (novos)
@nm_BancoDados char (20),
@nm_Server char (20),
@cd_usuario int, 
@dt_usuario datetime,
-- dados antes 
@nm_BancoDados_old char (20)
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE DBServer SET
         nm_BancoDados = @nm_BancoDados,
         nm_Server     = @nm_Server,
         cd_usuario    = @cd_usuario,   
         dt_usuario    = @dt_usuario   
   WHERE
         nm_BancoDados = @nm_BancoDados_old 
   if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

