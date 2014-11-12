
CREATE PROCEDURE [sp_UsuarioModulo]
@cd_usuario int,
@nm_modulo varchar(40)
AS
  SELECT COUNT(*) AS Permitido 
  FROM USUARIO_MODULO A, MODULO B
  WHERE 
        B.nm_modulo = @nm_modulo
    AND A.cd_modulo = B.cd_modulo 
    AND A.cd_usuario = @cd_usuario 

