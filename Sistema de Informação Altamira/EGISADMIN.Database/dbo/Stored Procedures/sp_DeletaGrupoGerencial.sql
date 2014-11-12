
CREATE procedure sp_DeletaGrupoGerencial
@cd_grupo_gerencial int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM Grupo_Gerencial
     WHERE
         cd_grupo_gerencial = @cd_grupo_gerencial
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

