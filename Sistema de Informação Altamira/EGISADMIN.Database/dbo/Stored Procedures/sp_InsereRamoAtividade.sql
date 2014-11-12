
CREATE procedure sp_InsereRamoAtividade
@cd_ramo_atividade int output,
@nm_ramo_atividade varchar (20) output,
@cd_usuario int output,
@dt_usuario datetime output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  -- gerar codigo e executa travamento
  SELECT @cd_ramo_atividade = ISNULL(MAX(cd_ramo_atividade),0) + 1 FROM RamoAtividade TABLOCK
  INSERT INTO RamoAtividade( cd_ramo_atividade,nm_ramo_atividade,cd_usuario,dt_usuario)
     VALUES (@cd_ramo_atividade,@nm_ramo_atividade,@cd_usuario,@dt_usuario)
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

