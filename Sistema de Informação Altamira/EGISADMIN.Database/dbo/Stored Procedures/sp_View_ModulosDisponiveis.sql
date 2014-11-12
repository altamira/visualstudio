
CREATE PROCEDURE [sp_View_ModulosDisponiveis] 
@cd_grupo_usuario int
AS
  SELECT cd_modulo, nm_modulo 
    FROM Modulo
   WHERE cd_modulo not in (SELECT cd_modulo FROM Modulo_GrupoUsuario
                            WHERE cd_grupo_usuario = @cd_grupo_usuario)

