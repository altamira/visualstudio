CREATE PROCEDURE [Mail].[Message.Add]
	@MessageId	NVARCHAR (MAX),
    @Sent		DATETIME,
	@Received	DATETIME,
    @From		NVARCHAR (MAX),
    @To			NVARCHAR (MAX),
    @Cc			NVARCHAR (MAX),
    @Bcc		NVARCHAR (MAX),
	@ReplyTo	NVARCHAR (MAX),
	@InReplyTo	NVARCHAR (MAX),
	@ReturnPath NVARCHAR (MAX),
    @Subject	NVARCHAR (MAX),
    @Body		VARBINARY (MAX)
AS
	/* 
	TODO Check if message exists before insert 
	*/
	INSERT INTO [Mail].[Message] ([MessageId], [Sent], [Received], [From], [To], [Cc], [Bcc], [ReplyTo], [InReplyTo], [ReturnPath], [Subject], [Body]) VALUES (@MessageId, @Sent, @Received, @From, @To, @Cc, @Bcc, @ReplyTo, @InReplyTo, @ReturnPath, @Subject, @Body)

RETURN 0
