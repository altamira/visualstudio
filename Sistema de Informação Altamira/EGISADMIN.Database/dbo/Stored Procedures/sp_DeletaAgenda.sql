
create procedure sp_DeletaAgenda
@dt_agenda datetime output,
@ic_dia_util char (1) output,
@ic_fabrica char (1) output,
@ic_plantao_vendas char (1) output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM Agenda
     WHERE
         dt_agenda = @dt_agenda and 
         ic_dia_util = @ic_dia_util and 
         ic_fabrica = @ic_fabrica and 
         ic_plantao_vendas = @ic_plantao_vendas
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

