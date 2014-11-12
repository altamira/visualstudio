
CREATE procedure sp_DeletaUsuario
@cd_usuario int output
AS
BEGIN
  DECLARE @loginame sysname
  Select @loginame = nm_fantasia_usuario from Usuario
      where cd_usuario = @cd_usuario
  --inicia a transaçao
  BEGIN TRANSACTION
  if exists(SELECT * from Usuario_GrupoUsuario where cd_usuario = @cd_usuario)
    DELETE FROM Usuario_GrupoUsuario
      WHERE cd_usuario = @cd_usuario
  if exists(SELECT * from Usuario_Config where cd_usuario = @cd_usuario)
    DELETE FROM Usuario_Config
      WHERE cd_usuario  = @cd_usuario
  if exists(SELECT * from Menu_Usuario where cd_usuario = @cd_usuario)
    DELETE FROM Menu_Usuario
      WHERE cd_usuario  = @cd_usuario
  if exists(SELECT * from historico_senha_usuario where cd_usuario = @cd_usuario)
    DELETE FROM historico_senha_usuario
      WHERE cd_usuario  = @cd_usuario
  DELETE FROM Usuario
     WHERE
         cd_usuario = @cd_usuario
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
  --EXEC sp_dropuser @loginame
  EXEC sp_droplogin @loginame
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON