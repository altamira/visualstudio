
CREATE procedure sp_DeletaNivelAcesso
@cd_nivel_acesso int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM NivelAcesso
     WHERE
         cd_nivel_acesso = @cd_nivel_acesso
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

