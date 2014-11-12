CREATE TABLE [Mail].[Message] (
    [Id]      INT             IDENTITY (1, 1) NOT NULL,
	[MessageId] NVARCHAR(MAX) NULL,
    [Sent]    DATETIME        NOT NULL,
	[Received] DATETIME		  NOT NULL,
    [From]    NVARCHAR (MAX)  NULL,
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

