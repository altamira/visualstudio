
CREATE procedure sp_InsereDominio
@cd_dominio int output,
@nm_dominio varchar (20) output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  -- gerar codigo e executa travamento
  SELECT @cd_dominio = ISNULL(MAX(cd_dominio),0) + 1 FROM Dominio TABLOCK
  INSERT INTO Dominio(cd_dominio,nm_dominio)
     VALUES (@cd_dominio,@nm_dominio)
  Select 
         @cd_dominio = cd_dominio,
         @nm_dominio = nm_dominio
  From Dominio
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

