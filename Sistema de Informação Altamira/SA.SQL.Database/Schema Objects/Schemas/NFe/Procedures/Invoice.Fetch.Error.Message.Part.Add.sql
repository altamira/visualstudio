CREATE PROCEDURE [NFe].[Invoice.Fetch.Error.Message.Part.Add]
	@Message		INT,
    @ContentType	NVARCHAR (50), 
    @MessagePart	NVARCHAR (MAX), 
    @Error			NVARCHAR (MAX)
AS
	INSERT INTO [NFe].[Invoice.Fetch.Error.Message.Part] ([Message], [ContentType], [MessagePart], [Error]) VALUES (@Message, @ContentType, @MessagePart, @Error)

RETURN 0
