CREATE TABLE [NFe].[Invoice] (
    [Id]     INT            IDENTITY (1, 1) NOT NULL,
    [Date]   DATETIME       NOT NULL,
    [Number] INT            NOT NULL,
	[From] NVARCHAR(100)  NULL,
	[To] NVARCHAR(100) NULL,
    [Key]    NCHAR(44)     NOT NULL,
    [Hash]   VARBINARY (64) NULL,
    [Xml]    XML            NOT NULL,
    CONSTRAINT [PK_NFe.Invoice] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO


CREATE TRIGGER [NFe].[Update.Hash]
   ON  [NFe].[Invoice]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE [NFe].[Invoice]
	SET [NFe].[Invoice].[Hash] = HASHBYTES('SHA1', CAST(inserted.[Xml] AS NVARCHAR(MAX)))
	FROM [NFe].[Invoice], inserted
	WHERE [NFe].[Invoice].Id = inserted.Id

END


GO

CREATE UNIQUE INDEX [IX_Key] ON [NFe].[Invoice] ([Key])
