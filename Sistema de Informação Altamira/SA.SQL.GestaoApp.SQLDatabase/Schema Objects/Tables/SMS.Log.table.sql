CREATE TABLE [SMS].[Log](
	[Guid] [uniqueidentifier] NOT NULL,
	[Date] [datetime] NOT NULL,
	[From] [nvarchar](50) NOT NULL,
	[Mobile] [nvarchar](14) NOT NULL,
	[Message] [nvarchar](max) NOT NULL,
	[Status] [int] NOT NULL,
	[Return] [nvarchar](max) NULL) ON [PRIMARY]










