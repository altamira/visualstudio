﻿/****** Object:  Default [DF_User_LastUpdateDate]    Script Date: 09/12/2011 14:41:55 ******/
/****** Object:  Default [DF_User_LastUpdateDate]    Script Date: 09/16/2011 11:33:30 ******/
/****** Object:  Default [DF_User_LastUpdateDate]    Script Date: 09/21/2011 17:29:26 ******/
/****** Object:  Default [DF_User_LastUpdateDate]    Script Date: 01/17/2012 12:44:41 ******/
ALTER TABLE [Security].[User] ADD  CONSTRAINT [DF_User_LastUpdateDate]  DEFAULT (getdate()) FOR [LastUpdateDate]
















