
CREATE procedure sp_AlteraGrupoUsuario
--dados depois da execuçao (novos)
@nm_grupo_usuario varchar (40),
@sg_grupo_usuario char (10),
@ic_tipo_grupo_usuario char (1),
--dados antes da execuçao (antigos)
@cd_grupo_usuario_old int
/*,
@nm_grupo_usuario_old varchar (40),
@sg_grupo_usuario_old char (10),
@ic_tipo_grupo_usuario_old char (1)
*/
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE GrupoUsuario SET
         nm_grupo_usuario = @nm_grupo_usuario,
         sg_grupo_usuario = @sg_grupo_usuario,
         ic_tipo_grupo_usuario = @ic_tipo_grupo_usuario
     WHERE
         cd_grupo_usuario = @cd_grupo_usuario_old
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

