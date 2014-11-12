/****** Object:  Default [DF_BidChangeLog_InsertDate]    Script Date: 09/21/2011 17:29:26 ******/
/****** Object:  Default [DF_BidChangeLog_InsertDate]    Script Date: 01/17/2012 12:44:41 ******/
ALTER TABLE [Sales].[BidChangeLog] ADD  CONSTRAINT [DF_BidChangeLog_InsertDate]  DEFAULT (getdate()) FOR [InsertDate]










