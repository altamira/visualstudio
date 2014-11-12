
CREATE procedure sp_DeletaFuncao
@cd_funcao int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  DELETE FROM Funcao
     WHERE
         cd_funcao = @cd_funcao
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

