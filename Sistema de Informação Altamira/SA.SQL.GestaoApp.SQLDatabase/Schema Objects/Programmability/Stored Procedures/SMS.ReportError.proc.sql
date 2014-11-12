CREATE PROCEDURE [SMS].[ReportError]
	@XmlRequest AS XML = NULL
AS
BEGIN
	SET NOCOUNT ON
	
	DECLARE @mailTo AS NVARCHAR(MAX)
	DECLARE @Mobile AS NVARCHAR(14)
    DECLARE @body AS NVARCHAR(MAX)
    
    DECLARE @Procedure AS NVARCHAR(50)
    DECLARE @Line AS NVARCHAR(10)
    DECLARE @Message AS NVARCHAR(MAX)
    
    SET @Procedure = CAST(ERROR_PROCEDURE() AS NVARCHAR(50))
    SET @Line = CAST(ERROR_LINE() AS NVARCHAR(10))
    SET @Message = CAST(ERROR_MESSAGE() AS NVARCHAR(MAX))
    
    SET @body =	--CASE WHEN ERROR_NUMBER() IS NULL THEN 'Number:' ELSE 'Number:' + CAST(ERROR_NUMBER() AS NVARCHAR(MAX)) END + CHAR(13) +
				--CASE WHEN ERROR_SEVERITY() IS NULL THEN 'Severity:' ELSE 'Severity:' + CAST(ERROR_SEVERITY() AS NVARCHAR(MAX)) END + CHAR(13) +
				--CASE WHEN ERROR_STATE() IS NULL THEN 'State:' ELSE 'State:' + CAST(ERROR_STATE() AS NVARCHAR(MAX)) END + CHAR(13) +
				CASE WHEN @Procedure IS NULL THEN 'Procedure: NULL' ELSE 'Procedure:' + @Procedure END + CHAR(13) +
				CASE WHEN @Line IS NULL THEN 'Line: NULL' ELSE 'Line:' + @Line END + CHAR(13) +
				CASE WHEN @Message IS NULL THEN 'Message: NULL' ELSE 'Message:' + @Message END + CHAR(13) + 
				CASE WHEN @XmlRequest IS NULL THEN 'Request: NULL' ELSE 'Request:' + CHAR(13) + CAST(@XmlRequest AS NVARCHAR(MAX)) END + CHAR(13)
    			
    SET @mailTo = 'alessandrohmachado@gmail.com'
			
	EXEC msdb.dbo.sp_send_dbmail
		@profile_name = 'SQLSendMail',
		@recipients = @mailTo,
		@subject = 'Altamira Report Error',
		@body =	@body;
		
	SET @Mobile = '551184420440'  -- Alessandro
	
	INSERT INTO SMS.[Log] ([From], [Mobile], [Message])
	SELECT 'ReportError', @Mobile, @body
			
	INSERT INTO dbo.ErrorLog ([Procedure], [Line], [Message], [Request]) VALUES (@Procedure, @Line, @Message, @XmlRequest)
END











