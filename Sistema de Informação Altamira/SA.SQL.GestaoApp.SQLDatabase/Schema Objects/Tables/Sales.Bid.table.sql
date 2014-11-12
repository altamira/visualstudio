CREATE TABLE [Sales].[Bid](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[Number] [nchar](8) NOT NULL,
	[Sales.Client.Id] [int] NOT NULL,
	[Sales.Vendor.Id] [int] NOT NULL,
	[Sales.PurchaseType.Id] [int] NOT NULL,
	[ContactPerson] [xml] NULL,
	[ContactPersonCopyTo] [xml] NULL,
	[LocationAddress] [xml] NULL,
	[Comments] [ntext] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateBy.Security.User.Id] [int] NOT NULL,
	[LastUpdateDate] [datetime] NULL,
	[LastUpdateBy.Security.User.Id] [int] NULL) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

















