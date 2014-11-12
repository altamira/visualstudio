CREATE TABLE [Location].[City](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [numeric](7, 0) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Flag] [image] NULL,
	[Location.State.Id] [int] NOT NULL) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]











