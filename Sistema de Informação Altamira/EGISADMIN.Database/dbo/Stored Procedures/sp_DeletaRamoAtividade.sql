
CREATE procedure sp_DeletaRamoAtividade
@cd_ramo_atividade int output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM RamoAtividade
     WHERE
         cd_ramo_atividade = @cd_ramo_atividade
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

