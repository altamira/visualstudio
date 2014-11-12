
CREATE procedure sp_AlteraDepartamento
--dados depois da execuçao (novos)
@cd_departamento int,
@nm_departamento varchar (40),
@sg_departamento char (10),
--dados antes da execuçao (antigos)
@cd_departamento_old int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE Departamento SET
         cd_departamento = @cd_departamento,
         nm_departamento = @nm_departamento,
         sg_departamento = @sg_departamento
     WHERE
         cd_departamento = @cd_departamento_old
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

