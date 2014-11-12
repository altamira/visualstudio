
CREATE procedure sp_AlteraDominio
--dados depois da execuçao (novos)
@nm_dominio varchar (20),
--dados antes da execuçao (antigos)
@cd_dominio_old int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE Dominio SET
         nm_dominio = @nm_dominio
     WHERE
         cd_dominio = @cd_dominio_old
/*
 and 
         nm_grupo_usuario = @nm_grupo_usuario_old and 
         sg_grupo_usuario = @sg_grupo_usuario_old and 
         ic_tipo_grupo_usuario = @ic_tipo_grupo_usuario_old
*/
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

