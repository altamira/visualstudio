
create procedure sp_AlteraDepartamento_Usuario
--dados depois da execuçao (novos)
@cd_departamento int,
@cd_usuario int,
--dados antes da execuçao (antigos)
@cd_departamento_old int,
@cd_usuario_old int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE Departamento_Usuario SET          cd_departamento = @cd_departamento,
         cd_usuario = @cd_usuario     WHERE
         cd_departamento = @cd_departamento_old and 
         cd_usuario = @cd_usuario_old
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

