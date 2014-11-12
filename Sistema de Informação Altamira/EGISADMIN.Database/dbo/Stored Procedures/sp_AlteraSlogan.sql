
CREATE PROCEDURE [sp_AlteraSlogan]
@cd_slogan int,
@nm_slogan varchar(30),
@ds_slogan text,
@ic_ativo_slogan char(1)
AS
  UPDATE Slogan set
         nm_slogan = @nm_slogan,
         ds_slogan = @ds_slogan,
         ic_ativo_slogan = @ic_ativo_slogan
   WHERE
         cd_slogan = @cd_slogan  
  if @ic_ativo_slogan = 'S' 
    UPDATE Slogan SET
           ic_ativo_slogan = 'N'
     WHERE 
           cd_slogan <> @cd_slogan
          

