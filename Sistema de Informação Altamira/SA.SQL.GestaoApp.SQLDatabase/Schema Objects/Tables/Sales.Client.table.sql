CREATE TABLE [Sales].[Client](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[CodeName] [nvarchar](100) NOT NULL,
	[ContactPerson] [xml] NULL,
	[LocationAddress] [xml] NULL,
	[Sales.Vendor.Id] [int] NOT NULL,
	[Contact.Media.Id] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateBy.Security.User.Id] [int] NOT NULL,
	[LastUpdateDate] [datetime] NULL,
	[LastUpdateBy.Security.User.Id] [int] NULL) ON [PRIMARY]



















