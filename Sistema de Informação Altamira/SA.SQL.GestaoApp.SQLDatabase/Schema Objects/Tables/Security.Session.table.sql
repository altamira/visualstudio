CREATE TABLE [Security].[Session](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Guid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[ExpireDate] [datetime] NOT NULL,
	[Language] [nvarchar](5) NULL,
	[CreateBy.Security.User.Id] [int] NOT NULL) ON [PRIMARY]









