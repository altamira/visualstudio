
CREATE TRIGGER [SMS].[LogTrigger]
   ON  [SMS].[Log] 
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	/*DECLARE @id NVARCHAR(MAX)
	DECLARE @from NVARCHAR(MAX)
	DECLARE @msg NVARCHAR(MAX)
	DECLARE @mobile NVARCHAR(MAX)

	SELECT 	@id = CAST(Id AS NVARCHAR(20)),
			@from = [From],
			@mobile = [Mobile],
			@msg = LEFT([Message], 140 - LEN([From]))
	FROM inserted
	
	EXEC Meta.SendSMS 'altamira', '8Zpee5u2x2', @msg, @from, @mobile, '', @id
	
	UPDATE Meta.SMSLog SET [Status] = 1 WHERE Id = @id*/

	exec msdb.dbo.sp_start_job @job_name = 'SMS.SendQueued'
END
