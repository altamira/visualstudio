
CREATE PROCEDURE [sp_View_Disp_Resp_Modulo]
@cd_modulo int
AS
  SELECT U.cd_usuario, U.nm_fantasia_usuario
  FROM Usuario U 
  WHERE cd_usuario not in (SELECT cd_usuario FROM Modulo_Responsavel MR 
                            WHERE MR.cd_modulo = @cd_modulo )
  ORDER BY nm_fantasia_usuario

