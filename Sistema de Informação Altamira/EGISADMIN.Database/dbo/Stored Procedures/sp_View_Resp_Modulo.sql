
CREATE PROCEDURE [sp_View_Resp_Modulo]
@cd_modulo int
AS
  SELECT U.cd_usuario, U.nm_fantasia_usuario
  FROM Usuario U INNER JOIN Modulo_Responsavel MR ON 
     MR.cd_usuario = U.cd_usuario
  WHERE MR.cd_modulo = @cd_modulo
  ORDER BY nm_fantasia_usuario
  

