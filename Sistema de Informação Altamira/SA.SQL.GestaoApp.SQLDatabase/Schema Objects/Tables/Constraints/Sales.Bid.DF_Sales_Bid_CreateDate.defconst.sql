/****** Object:  Default [DF_Sales_Bid_CreateDate]    Script Date: 09/21/2011 17:29:26 ******/
/****** Object:  Default [DF_Sales_Bid_CreateDate]    Script Date: 01/17/2012 12:44:46 ******/
ALTER TABLE [Sales].[Bid] ADD  CONSTRAINT [DF_Sales_Bid_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]





