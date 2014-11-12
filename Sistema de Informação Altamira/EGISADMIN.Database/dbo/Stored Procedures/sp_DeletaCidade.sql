
CREATE procedure sp_DeletaCidade
@cd_pais int output,
@cd_estado int output,
@cd_cidade int output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM Cidade
     WHERE
         cd_pais = @cd_pais and 
         cd_estado = @cd_estado and 
         cd_cidade = @cd_cidade
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

