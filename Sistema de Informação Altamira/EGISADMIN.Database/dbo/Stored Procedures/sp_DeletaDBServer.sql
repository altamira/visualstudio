
CREATE procedure sp_DeletaDBServer
@nm_BancoDados char(20)
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM DBServer
     WHERE
         nm_BancoDados = @nm_BancoDados
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON

