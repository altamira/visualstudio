
CREATE procedure sp_AlteraPais
--dados depois da execuçao (novos)
@nm_pais varchar (20),
@sg_pais char (3),
@cd_ddi_pais char (2),
@cd_usuario int,
@dt_usuario datetime,
--dados antes da execuçao (antigos)
@cd_pais_old int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE Pais SET
         nm_pais = @nm_pais,
         sg_pais = @sg_pais,
         cd_ddi_pais = @cd_ddi_pais,
         cd_usuario = @cd_usuario,
         dt_usuario = @dt_usuario
     WHERE
         cd_pais = @cd_pais_old
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

