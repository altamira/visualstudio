
CREATE procedure sp_AlteraEstado
--dados depois da execuçao (novos)
@nm_estado varchar (20),
@sg_estado char (2),
--dados antes da execuçao (antigos)
@cd_pais_old int ,
@cd_estado_old int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE Estado SET
         nm_estado = @nm_estado,
         sg_estado = @sg_estado
     WHERE
         cd_pais = @cd_pais_old and 
         cd_estado = @cd_estado_old
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

