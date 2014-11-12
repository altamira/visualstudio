

CREATE PROCEDURE sp_View_ModuloNaoAssociado
@cd_usuario int
AS
  SELECT M.cd_modulo, M.nm_modulo, M.nm_Executavel
    FROM Usuario_GrupoUsuario UGU,
         Modulo_GrupoUsuario MGU,
         Modulo M
   WHERE UGU.cd_grupo_usuario = MGU.cd_grupo_usuario
     AND M.cd_modulo = MGU.cd_modulo
     AND UGU.cd_usuario = @cd_usuario
     AND MGU.cd_modulo not in (SELECT IsNull(cd_modulo,0) FROM Usuario_Config
                                WHERE cd_usuario = @cd_usuario)
   ORDER BY nm_modulo



