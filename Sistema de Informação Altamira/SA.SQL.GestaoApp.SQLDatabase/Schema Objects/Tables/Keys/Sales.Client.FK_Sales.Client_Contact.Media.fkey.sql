/****** Object:  ForeignKey [FK_Sales.Client_Contact.Media]    Script Date: 09/16/2011 11:33:30 ******/
/****** Object:  ForeignKey [FK_Sales.Client_Contact.Media]    Script Date: 09/21/2011 17:29:26 ******/
/****** Object:  ForeignKey [FK_Sales.Client_Contact.Media]    Script Date: 01/17/2012 12:44:43 ******/
ALTER TABLE [Sales].[Client]  ADD  CONSTRAINT [FK_Sales.Client_Contact.Media] FOREIGN KEY([Contact.Media.Id])
REFERENCES [Contact].[Media] ([Id])













GO
ALTER TABLE [Sales].[Client] CHECK CONSTRAINT [FK_Sales.Client_Contact.Media]

