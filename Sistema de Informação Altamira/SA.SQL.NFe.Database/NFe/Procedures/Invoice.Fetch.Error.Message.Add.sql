CREATE PROCEDURE [NFe].[Invoice.Fetch.Error.Message.Add]
	@Sent	DATETIME,
    @From	NVARCHAR(MAX), 
    @To		NVARCHAR(MAX), 
    @Cc		NVARCHAR(MAX), 
    @Bcc	NVARCHAR(MAX), 
    @Subject NVARCHAR(MAX), 
    @Body	VARBINARY(MAX) 
AS
	SET NOCOUNT ON; 
	
	INSERT INTO [NFe].[Invoice.Fetch.Error.Message] ([Sent], [From], [To], [Cc], [Bcc], [Subject], [Body]) VALUES (@Sent, @From, @To, @Cc, @Bcc, @Subject, @Body)
	
	SELECT CAST(SCOPE_IDENTITY() AS INT) AS Id
		
	RETURN CAST(SCOPE_IDENTITY() AS INT)
