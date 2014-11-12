CREATE TABLE [Shipping].[PackingList](
	[Id] [int] NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[Client.Id] [int] NOT NULL,
	[Vendor.Id] [int] NOT NULL,
	[Bid.Id] [int] NOT NULL,
	[Order.Number] [int] NOT NULL,
	[Items] [xml] NOT NULL,
	[Comments] [nvarchar](max) NULL) ON [PRIMARY]









