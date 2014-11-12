
CREATE PROCEDURE sp_InsereDBServer 
@nm_BancoDados char(20),
@nm_Servidor char(20),
@cd_usuario int,
@dt_usuario datetime
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  INSERT INTO DBServer ( nm_BancoDados,
                         nm_Servidor,
                         cd_usuario,
                         dt_usuario)
       VALUES (@nm_BancoDados,
               @nm_Servidor,
               @cd_usuario,
               @dt_usuario)
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON

