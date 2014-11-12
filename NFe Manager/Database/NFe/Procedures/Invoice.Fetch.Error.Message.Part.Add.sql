CREATE PROCEDURE [NFe].[Invoice.Fetch.Error.Message.Part.Add]
	@Message		INT,
    @ContentType	NVARCHAR (50), 
    @MessagePart	NVARCHAR (MAX),
	@ExceptionType  NVARCHAR(50), 
    @Error			NVARCHAR (MAX)
AS
	INSERT INTO [NFe].[Invoice.Fetch.Error.Message.Part] ([Message], [ContentType], [MessagePart], [ExceptionType], [Error]) VALUES (@Message, @ContentType, @MessagePart, @ExceptionType, @Error)

RETURN 0
