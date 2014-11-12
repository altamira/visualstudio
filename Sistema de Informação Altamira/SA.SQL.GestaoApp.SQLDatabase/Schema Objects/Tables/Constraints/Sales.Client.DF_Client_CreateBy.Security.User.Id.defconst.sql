/****** Object:  Default [DF_Client_CreateBy.Security.User.Id]    Script Date: 09/16/2011 11:33:30 ******/
/****** Object:  Default [DF_Client_CreateBy.Security.User.Id]    Script Date: 09/21/2011 17:29:26 ******/
/****** Object:  Default [DF_Client_CreateBy.Security.User.Id]    Script Date: 01/17/2012 12:44:43 ******/
ALTER TABLE [Sales].[Client] ADD  CONSTRAINT [DF_Client_CreateBy.Security.User.Id]  DEFAULT ((1)) FOR [CreateBy.Security.User.Id]











