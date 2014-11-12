
create procedure sp_InsereAgenda_Feriado
@dt_agenda datetime output,
@cd_feriado int output,
@nm_observacao_feriado varchar (30) output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  INSERT INTO Agenda_Feriado( dt_agenda,cd_feriado,nm_observacao_feriado)
     VALUES (@dt_agenda,@cd_feriado,@nm_observacao_feriado)
  Select 
         @dt_agenda = dt_agenda,
         @cd_feriado = cd_feriado,
         @nm_observacao_feriado = nm_observacao_feriado
  From Agenda_Feriado
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

