CREATE TABLE [dbo].[NFe] (
    [Id]     INT            IDENTITY (1, 1) NOT NULL,
    [Date]   DATETIME       NOT NULL,
    [Number] INT            NOT NULL,
    [Key]    NCHAR (44)     NOT NULL,
    [Hash]   VARBINARY (20) NOT NULL,
    [Xml]    XML            NOT NULL,
    CONSTRAINT [PK_NFe] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO


CREATE TRIGGER [dbo].[NFE_INSER_UPDATE_HASH]
   ON  [dbo].[NFe]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE NFe
	SET NFe.[Hash] = HASHBYTES('SHA1', CAST(inserted.[Xml] AS NVARCHAR(MAX)))
	FROM NFe, inserted
	WHERE NFe.Id = inserted.Id

END

