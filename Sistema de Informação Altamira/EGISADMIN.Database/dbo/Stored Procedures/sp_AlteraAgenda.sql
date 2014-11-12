
create procedure sp_AlteraAgenda
--dados depois da execuçao (novos)
@dt_agenda datetime,
@ic_dia_util char (1),
@ic_fabrica char (1),
@ic_plantao_vendas char (1),
--dados antes da execuçao (antigos)
@dt_agenda_old datetime,
@ic_dia_util_old char (1),
@ic_fabrica_old char (1),
@ic_plantao_vendas_old char (1)
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE Agenda SET 
         dt_agenda = @dt_agenda,
         ic_dia_util = @ic_dia_util,
         ic_fabrica = @ic_fabrica,
         ic_plantao_vendas = @ic_plantao_vendas
     WHERE
         dt_agenda = @dt_agenda_old and 
         ic_dia_util = @ic_dia_util_old and 
         ic_fabrica = @ic_fabrica_old and 
         ic_plantao_vendas = @ic_plantao_vendas_old
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

