﻿
/****** Object:  ForeignKey [FK_Sales.Bid_Sales.Client]    Script Date: 09/16/2011 11:33:30 ******/
/****** Object:  ForeignKey [FK_Sales.Bid_Sales.Client]    Script Date: 09/21/2011 17:29:26 ******/
/****** Object:  ForeignKey [FK_Sales.Bid_Sales.Client]    Script Date: 01/17/2012 12:44:46 ******/
ALTER TABLE [Sales].[Bid]  ADD  CONSTRAINT [FK_Sales.Bid_Sales.Client] FOREIGN KEY([Sales.Client.Id])
REFERENCES [Sales].[Client] ([Id])

















GO
ALTER TABLE [Sales].[Bid] CHECK CONSTRAINT [FK_Sales.Bid_Sales.Client]

