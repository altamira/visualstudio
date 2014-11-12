CREATE TABLE [Location].[Country](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[ISOCountryCodeCh2] [char](2) NOT NULL,
	[ISOCountryCodeCh3] [char](3) NOT NULL,
	[CallingCode] [int] NOT NULL,
	[Flag] [image] NULL) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]











