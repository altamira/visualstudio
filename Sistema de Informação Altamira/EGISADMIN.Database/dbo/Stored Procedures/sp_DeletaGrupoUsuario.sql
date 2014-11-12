
CREATE procedure sp_DeletaGrupoUsuario
@cd_grupo_usuario int output
/*
,
@nm_grupo_usuario varchar (40) output,
@sg_grupo_usuario char (10) output,
@ic_tipo_grupo_usuario char (1) output
*/
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM GrupoUsuario
     WHERE
         cd_grupo_usuario = @cd_grupo_usuario
/*
 and 
         nm_grupo_usuario = @nm_grupo_usuario and 
         sg_grupo_usuario = @sg_grupo_usuario and 
         ic_tipo_grupo_usuario = @ic_tipo_grupo_usuario
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

