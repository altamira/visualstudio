CREATE TABLE [NFe].[Invoice] (
    [Id]     INT            IDENTITY (1, 1) NOT NULL,
    [Date]   DATETIME       NOT NULL,
    [Number] INT            NOT NULL,
	[Value]  MONEY			NOT NULL DEFAULT(0),
	[Sender] NVARCHAR(MAX)  NULL,
	[Receipt] NVARCHAR(MAX) NULL,
    [Key]    NVARCHAR(44)     NOT NULL,
	[Type]  SMALLINT NOT NULL DEFAULT(0),
	[Status] SMALLINT NOT NULL DEFAULT(0),
    [Hash]   VARBINARY (64) NULL,
    [Xml]    XML            NOT NULL,
    CONSTRAINT [PK_NFe.Invoice] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO




GO

CREATE UNIQUE INDEX [IX_Key] ON [NFe].[Invoice] ([Key])
