
CREATE procedure sp_AlteraOperadora_Telefonia
--dados depois da execuçao (novos)
@nm_operadoroa varchar (20),
@sg_operadora char (5),
@cd_servico_operadora char (2),
--dados antes da execuçao (antigos)
@cd_operadora_old int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE Operadora_Telefonia SET
         nm_operadoroa = @nm_operadoroa,
         sg_operadora = @sg_operadora,
         cd_servico_operadora = @cd_servico_operadora    
      WHERE
         cd_operadora = @cd_operadora_old
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

