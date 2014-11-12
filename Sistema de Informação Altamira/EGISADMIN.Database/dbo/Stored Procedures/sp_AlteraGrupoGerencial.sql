
CREATE procedure sp_AlteraGrupoGerencial
--dados depois da execuçao (novos)
@nm_grupo_gerencial varchar (20),
@nu_ordem int,
--dados antes da execuçao (antigos)
@cd_grupo_gerencial_old int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE Grupo_Gerencial SET
         nm_grupo_gerencial   = @nm_grupo_gerencial,
         nu_ordem             = @nu_ordem
   WHERE
         cd_grupo_gerencial   = @cd_grupo_gerencial_old
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

