
CREATE PROCEDURE [sp_InsereMenu_GrupoUsuario] 
@cd_grupo_usuario int,
@cd_menu int,
@cd_nivel_acesso int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  INSERT INTO Menu_GrupoUsuario (cd_grupo_usuario,cd_menu,cd_nivel_acesso) VALUES (@cd_grupo_usuario,@cd_menu,@cd_nivel_acesso)
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

