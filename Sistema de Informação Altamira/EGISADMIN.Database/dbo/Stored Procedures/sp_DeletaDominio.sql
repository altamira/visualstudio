
CREATE procedure sp_DeletaDominio
@cd_dominio int output,
@nm_dominio varchar (20) output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM Conteudo_Dominio
     WHERE cd_Dominio = @cd_Dominio 
  DELETE FROM Dominio
     WHERE
         cd_Dominio = @cd_Dominio
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

