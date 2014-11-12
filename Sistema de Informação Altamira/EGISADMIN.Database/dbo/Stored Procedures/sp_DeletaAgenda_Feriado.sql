
create procedure sp_DeletaAgenda_Feriado
@dt_agenda datetime output,
@cd_feriado int output,
@nm_observacao_feriado varchar (30) output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM Agenda_Feriado
     WHERE
         dt_agenda = @dt_agenda and 
         cd_feriado = @cd_feriado and
         nm_observacao_feriado = @nm_observacao_feriado
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

