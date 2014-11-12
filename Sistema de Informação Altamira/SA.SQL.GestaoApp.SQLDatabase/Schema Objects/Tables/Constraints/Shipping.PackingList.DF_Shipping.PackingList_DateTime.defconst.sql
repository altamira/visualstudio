/****** Object:  Default [DF_Shipping.PackingList_DateTime]    Script Date: 09/21/2011 17:29:26 ******/
/****** Object:  Default [DF_Shipping.PackingList_DateTime]    Script Date: 01/17/2012 12:44:41 ******/
ALTER TABLE [Shipping].[PackingList] ADD  CONSTRAINT [DF_Shipping.PackingList_DateTime]  DEFAULT (getdate()) FOR [DateTime]










