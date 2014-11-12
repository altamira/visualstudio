
CREATE procedure sp_DeletaEstado
@cd_pais int output,
@cd_estado int output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM Estado
     WHERE
         cd_pais = @cd_pais and 
         cd_estado = @cd_estado
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

