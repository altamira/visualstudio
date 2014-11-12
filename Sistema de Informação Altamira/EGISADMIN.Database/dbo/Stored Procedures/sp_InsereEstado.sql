
CREATE procedure sp_InsereEstado
@cd_pais int output,
@cd_estado int output,
@nm_estado varchar (20) output,
@sg_estado char (2) output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  -- gerar codigo e executa travamento
  SELECT @cd_estado = ISNULL(MAX(cd_estado),0) + 1 FROM Estado TABLOCK
  INSERT INTO Estado( cd_pais,
                      cd_estado,
                      nm_estado,
                      sg_estado)
     VALUES (@cd_pais,
             @cd_estado,
             @nm_estado,
             @sg_estado)
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

