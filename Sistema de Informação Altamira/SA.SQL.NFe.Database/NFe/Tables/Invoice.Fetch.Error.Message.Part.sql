CREATE TABLE [NFe].[Invoice.Fetch.Error.Message.Part]
(
	[Id] INT NOT NULL IDENTITY PRIMARY KEY, 
	[Message] INT NOT NULL,
    [ContentType] NVARCHAR(50) NOT NULL, 
    [MessagePart] NVARCHAR(MAX) NOT NULL, 
	[ExceptionType] NVARCHAR(50) NOT NULL,
    [Error] NVARCHAR(MAX) NOT NULL
)
