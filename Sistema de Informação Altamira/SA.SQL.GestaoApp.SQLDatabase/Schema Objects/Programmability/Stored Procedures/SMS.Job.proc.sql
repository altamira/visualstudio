CREATE PROCEDURE [SMS].[Job]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @guid NVARCHAR(MAX)
	DECLARE @from NVARCHAR(MAX)
	DECLARE @msg NVARCHAR(MAX)
	DECLARE @mobile NVARCHAR(MAX)

	WHILE EXISTS(SELECT * FROM SMS.[Log] WHERE [Status] = 0)
	BEGIN
		SELECT TOP 1 @guid = [Guid],
				@from = [From],
				@mobile = [Mobile],
				@msg = LEFT([Message], 140 - LEN([From]))
		FROM SMS.[Log] WHERE [Status] = 0
		
		EXEC SMS.[Send] @msg, /*@from*/'', @mobile, @guid
		
		UPDATE SMS.[Log] SET [Status] = 1 WHERE [Guid] = @guid
	END
	
END












