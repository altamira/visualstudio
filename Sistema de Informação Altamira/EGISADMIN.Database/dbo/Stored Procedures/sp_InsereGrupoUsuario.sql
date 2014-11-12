
CREATE procedure sp_InsereGrupoUsuario
@cd_grupo_usuario int output,
@nm_grupo_usuario varchar (40) output,
@sg_grupo_usuario char (10) output,
@ic_tipo_grupo_usuario char (1) output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  -- gerar codigo e executa travamento
  SELECT @cd_grupo_usuario = ISNULL(MAX(cd_grupo_usuario),0) + 1 FROM GrupoUsuario TABLOCK
  INSERT INTO GrupoUsuario( cd_grupo_usuario,nm_grupo_usuario,sg_grupo_usuario,ic_tipo_grupo_usuario)
     VALUES (@cd_grupo_usuario,@nm_grupo_usuario,@sg_grupo_usuario,@ic_tipo_grupo_usuario)
  Select 
         @cd_grupo_usuario = cd_grupo_usuario,
         @nm_grupo_usuario = nm_grupo_usuario,
         @sg_grupo_usuario = sg_grupo_usuario,
         @ic_tipo_grupo_usuario = ic_tipo_grupo_usuario
  From GrupoUsuario
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

