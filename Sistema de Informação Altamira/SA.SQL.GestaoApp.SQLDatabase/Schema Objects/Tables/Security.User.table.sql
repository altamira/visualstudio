CREATE TABLE [Security].[User](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](40) NOT NULL,
	[Email] [nvarchar](50) NULL,
	[Perfil] [int] NOT NULL,
	[Rules] [nvarchar](max) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateBy] [int] NOT NULL,
	[LastUpdateDate] [datetime] NOT NULL,
	[LastUpdateBy] [int] NOT NULL,
	[LastLoginDate] [datetime] NULL) ON [PRIMARY]
















