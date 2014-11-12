
CREATE procedure sp_DeletaEmpresa
@cd_empresa int output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM Empresa
     WHERE
         cd_empresa = @cd_empresa
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

