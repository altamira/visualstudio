
CREATE PROCEDURE [sp_deletaSlogan]
@cd_slogan int
 AS
  DELETE FROM Slogan
   WHERE cd_slogan = @cd_slogan

