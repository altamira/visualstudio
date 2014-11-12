
CREATE procedure sp_InsereOperadora_Telefonia
@cd_operadora int output,
@nm_operadoroa varchar (20) output,
@sg_operadora char (5) output,
@cd_servico_operadora char (2) output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  -- gerar codigo e executa travamento
  SELECT @cd_operadora = ISNULL(MAX(cd_operadora),0) + 1 FROM Operadora_Telefonia TABLOCK
  INSERT INTO Operadora_Telefonia( cd_operadora,nm_operadoroa,sg_operadora,cd_servico_operadora)
     VALUES (@cd_operadora,@nm_operadoroa,@sg_operadora,@cd_servico_operadora)
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

