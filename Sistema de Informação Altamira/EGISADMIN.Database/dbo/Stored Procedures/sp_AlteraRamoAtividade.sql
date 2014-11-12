
CREATE procedure sp_AlteraRamoAtividade
--dados depois da execuçao (novos)
@nm_ramo_atividade varchar (20),
@cd_usuario int,
@dt_usuario datetime ,
--dados antes da execuçao (antigos)
@cd_ramo_atividade_old int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE RamoAtividade SET
         nm_ramo_atividade = @nm_ramo_atividade,
         cd_usuario = @cd_usuario,
         dt_usuario = @dt_usuario
     WHERE
         cd_ramo_atividade = @cd_ramo_atividade_old
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

