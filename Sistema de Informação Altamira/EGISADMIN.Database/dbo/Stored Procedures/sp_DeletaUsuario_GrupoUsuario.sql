
create procedure sp_DeletaUsuario_GrupoUsuario
@cd_grupo_usuario int output,
@cd_usuario int output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM Usuario_GrupoUsuario
     WHERE
         cd_grupo_usuario = @cd_grupo_usuario and 
         cd_usuario = @cd_usuario
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

