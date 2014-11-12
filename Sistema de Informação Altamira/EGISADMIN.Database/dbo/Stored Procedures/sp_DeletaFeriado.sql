
create procedure sp_DeletaFeriado
@cd_feriado int output,
@nm_feriado varchar (30) output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM Feriado
     WHERE
         cd_feriado = @cd_feriado and 
         nm_feriado = @nm_feriado
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

