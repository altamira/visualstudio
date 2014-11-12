
CREATE PROCEDURE [sp_DeletaMenu_GrupoUsuario] 
@cd_grupo_usuario int,
@cd_menu int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM Menu_GrupoUsuario 
   WHERE cd_grupo_usuario = @cd_grupo_usuario
     AND cd_menu          = @cd_menu
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

