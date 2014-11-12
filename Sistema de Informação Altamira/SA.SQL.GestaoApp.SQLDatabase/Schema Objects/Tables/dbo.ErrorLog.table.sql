CREATE TABLE [dbo].[ErrorLog](
	[DateTime] [datetime] NOT NULL,
	[Procedure] [nvarchar](50) NULL,
	[Line] [nchar](10) NULL,
	[Message] [nvarchar](max) NULL,
	[Request] [xml] NULL
) ON [PRIMARY]





