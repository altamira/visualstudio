
create procedure sp_AlteraAgenda_Feriado
--dados depois da execuçao (novos)
@dt_agenda datetime,
@cd_feriado int,
@nm_observacao_feriado varchar (30),
--dados antes da execuçao (antigos)
@dt_agenda_old datetime,
@cd_feriado_old int,
@nm_observacao_feriado_old varchar (30)
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE Agenda_Feriado SET
         dt_agenda = @dt_agenda,
         cd_feriado = @cd_feriado,
         nm_observacao_feriado = @nm_observacao_feriado
     WHERE
         dt_agenda = @dt_agenda_old and 
         cd_feriado = @cd_feriado_old and
         nm_observacao_feriado = @nm_observacao_feriado
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

