
create procedure sp_AlteraFeriado
--dados depois da execuçao (novos)
@cd_feriado int,
@nm_feriado varchar (30),
--dados antes da execuçao (antigos)
@cd_feriado_old int,
@nm_feriado_old varchar (30)
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE Feriado SET
         cd_feriado = @cd_feriado,
         nm_feriado = @nm_feriado
     WHERE
         cd_feriado = @cd_feriado_old and 
         nm_feriado = @nm_feriado_old
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

