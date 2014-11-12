/****** Object:  Default [DF_Bid.Header.Vendor.Id]    Script Date: 09/12/2011 14:41:55 ******/
/****** Object:  Default [DF_Bid.Header.Vendor.Id]    Script Date: 09/13/2011 11:13:11 ******/
/****** Object:  Default [DF_Bid.Header.Vendor.Id]    Script Date: 09/16/2011 11:33:30 ******/
ALTER TABLE [Sales].[Bid] ADD  CONSTRAINT [DF_Bid.Header.Vendor.Id]  DEFAULT ((0)) FOR [Sales.Vendor.Id]













