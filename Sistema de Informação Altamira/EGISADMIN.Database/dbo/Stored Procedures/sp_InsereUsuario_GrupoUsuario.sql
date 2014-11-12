
create procedure sp_InsereUsuario_GrupoUsuario
@cd_grupo_usuario int output,
@cd_usuario int output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  INSERT INTO Usuario_GrupoUsuario( cd_grupo_usuario,cd_usuario)
     VALUES (@cd_grupo_usuario,@cd_usuario)
  Select 
         @cd_grupo_usuario = cd_grupo_usuario,
         @cd_usuario = cd_usuario
  From Usuario_GrupoUsuario
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

