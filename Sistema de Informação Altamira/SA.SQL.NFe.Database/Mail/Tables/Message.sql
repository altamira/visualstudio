CREATE TABLE [Mail].[Message] (
    [Id]      INT             IDENTITY (1, 1) NOT NULL,
	[MessageId] NVARCHAR(512) NULL,
    [Sent]    DATETIME        NOT NULL,
	[Received] DATETIME		  NOT NULL,
    [From]    NVARCHAR (512)  NULL,
    [To]      NVARCHAR (MAX)  NULL,
    [Cc]      NVARCHAR (MAX)  NULL,
    [Bcc]     NVARCHAR (MAX)  NULL,
	[ReplyTo] NVARCHAR(MAX) NULL,
	[InReplyTo] NVARCHAR(MAX) NULL,
	[ReturnPath] NVARCHAR(MAX) NULL,
    [Subject] NVARCHAR (MAX)  NULL,
    [Body]    VARBINARY (MAX) NOT NULL,
    CONSTRAINT [PK_Inbox] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

CREATE INDEX [IX_Message_Id] ON [Mail].[Message] ([MessageId])

GO

CREATE INDEX [IX_Message_From] ON [Mail].[Message] ([From])

GO

CREATE INDEX [IX_Message_FindKey] ON [Mail].[Message] ([MessageId], [Sent], [From])
