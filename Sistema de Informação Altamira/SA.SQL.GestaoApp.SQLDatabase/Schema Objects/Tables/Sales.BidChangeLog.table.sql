CREATE TABLE [Sales].[BidChangeLog](
	[InsertDate] [datetime] NOT NULL,
	[InsertedBy] [int] NOT NULL,
	[UpdateDate] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[XmlRequest] [xml] NOT NULL,
	[XmlResponse] [xml] NULL
) ON [PRIMARY]







