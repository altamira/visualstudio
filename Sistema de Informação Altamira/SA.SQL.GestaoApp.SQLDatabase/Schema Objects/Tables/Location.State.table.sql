CREATE TABLE [Location].[State](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [numeric](2, 0) NOT NULL,
	[Acronym] [char](2) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Location.CityCapital.Id] [int] NOT NULL,
	[Location.Country.Id] [int] NOT NULL,
	[Flag] [image] NULL) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]










