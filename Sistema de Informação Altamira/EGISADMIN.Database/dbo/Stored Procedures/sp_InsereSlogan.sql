
CREATE PROCEDURE [sp_InsereSlogan]
@cd_slogan int output,
@nm_slogan varchar(30),
@ds_slogan text,
@ic_ativo_slogan char(1)
AS
BEGIN
  BEGIN TRANSACTION
  SELECT @cd_slogan = IsNull(Max(cd_slogan),0)+1
    FROM Slogan TABLOCK
  INSERT INTO Slogan (cd_slogan,
                      nm_slogan,
                      ds_slogan,
                      ic_ativo_slogan) 
       Values (@cd_slogan,
               @nm_slogan,
               @ds_slogan,
               @ic_ativo_slogan) 
  IF @ic_ativo_slogan = 'S'
    UPDATE Slogan SET
           ic_ativo_slogan = 'N'
     WHERE cd_slogan <> @cd_slogan
              
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

