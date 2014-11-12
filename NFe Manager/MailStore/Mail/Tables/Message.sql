CREATE TABLE [Mail].[Message] (
    [Id]      INT             IDENTITY (1, 1) NOT NULL,
	[MessageId] VARCHAR(512) NULL,
    [Sent]    DATETIME        NOT NULL,
	[Received] DATETIME		  NOT NULL,
    [From]    VARCHAR(512)  NULL,
    [To]      VARCHAR(MAX)  NULL,
    [Cc]      VARCHAR(MAX)  NULL,
    [Bcc]     VARCHAR(MAX)  NULL,
	[ReplyTo] VARCHAR(MAX) NULL,
	[InReplyTo] VARCHAR(MAX) NULL,
	[ReturnPath] VARCHAR(MAX) NULL,
    [Subject] VARCHAR(MAX)  NULL,
    [Body]    VARBINARY (MAX) NOT NULL,
    CONSTRAINT [PK_Inbox] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

CREATE INDEX [IX_Message_MessageId] ON [Mail].[Message] ([MessageId])

GO

CREATE INDEX [IX_Message_From] ON [Mail].[Message] ([From])

GO

