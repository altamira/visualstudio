
create procedure sp_InsereAgenda
@dt_agenda datetime output,
@ic_dia_util char (1) output,
@ic_fabrica char (1) output,
@ic_plantao_vendas char (1) output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  INSERT INTO Agenda( dt_agenda,ic_dia_util,ic_fabrica,ic_plantao_vendas)
     VALUES (@dt_agenda,@ic_dia_util,@ic_fabrica,@ic_plantao_vendas)
  Select 
         @dt_agenda = dt_agenda,
         @ic_dia_util = ic_dia_util,
         @ic_fabrica = ic_fabrica,
         @ic_plantao_vendas = ic_plantao_vendas
  From Agenda
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

