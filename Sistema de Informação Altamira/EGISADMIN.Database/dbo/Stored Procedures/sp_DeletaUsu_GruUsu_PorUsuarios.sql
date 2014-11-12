
CREATE PROCEDURE [sp_DeletaUsu_GruUsu_PorUsuarios]
@cd_usuario int
AS
  BEGIN TRAN
  DELETE FROM Usuario_GrupoUsuario
    WHERE cd_usuario = @cd_usuario
  IF (@@ERROR<>0)
    ROLLBACK TRAN
  ELSE
    COMMIT TRAN
     

