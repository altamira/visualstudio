
create procedure sp_InsereFeriado
@cd_feriado integer output,
@nm_feriado varchar (30) output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  -- gerar codigo e executa travamento
  SELECT @cd_feriado = ISNULL(MAX(cd_feriado),0) + 1 FROM Feriado TABLOCK
  INSERT INTO Feriado( cd_feriado,nm_feriado)
     VALUES (@cd_feriado,@nm_feriado)
  Select 
         @cd_feriado = cd_feriado,
         @nm_feriado = nm_feriado
  From Feriado
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

