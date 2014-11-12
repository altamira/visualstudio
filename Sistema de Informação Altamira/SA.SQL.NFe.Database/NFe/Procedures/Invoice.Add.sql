CREATE PROCEDURE [NFe].[Invoice.Add]
	@Date	DATETIME,
    @Number	INT,
	@Value	MONEY,
	@Sender	NVARCHAR(MAX),
	@Receipt NVARCHAR(MAX),
    @Key    NVARCHAR(44),
	@Type   SMALLINT,
	@Status SMALLINT,
    @Hash   VARBINARY(64),
    @Xml    XML
AS

	IF NOT EXISTS (SELECT * FROM [NFe].[Invoice] WHERE [Key] = @Key)
	BEGIN
		INSERT INTO [NFe].[Invoice] 
			([Date], [Number], [Value], [Sender], [Receipt], [Key], [Type], [Status], [Hash], [Xml]) 
		VALUES 
			(@Date, @Number, @Value, UPPER(LTRIM(RTRIM(REPLACE(@Sender, '*', '')))), UPPER(LTRIM(RTRIM(REPLACE(@Receipt, '*', '')))), @Key, @Type, @Status, @Hash, @Xml)
	END

RETURN 0
