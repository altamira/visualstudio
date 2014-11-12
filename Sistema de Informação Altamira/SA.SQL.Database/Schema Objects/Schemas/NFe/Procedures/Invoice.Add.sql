CREATE PROCEDURE [NFe].[Invoice.Add]
	@Date	DATETIME,
    @Number	INT,
	@From	NVARCHAR(100),
	@To		NVARCHAR(100),
    @Key    NCHAR(44),
    @Hash   VARBINARY(64),
    @Xml    XML
AS

	IF NOT EXISTS (SELECT * FROM [NFe].[Invoice] WHERE [Key] = @Key)
	BEGIN
		INSERT INTO [NFe].[Invoice] ([Date], [Number], [From], [To], [Key], [Hash], [Xml]) VALUES (@Date, @Number, @From, @To, @Key, @Hash, @Xml)
	END

RETURN 0
