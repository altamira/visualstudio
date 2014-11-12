/****** Object:  Default [DF_Session_CreateDate]    Script Date: 09/21/2011 17:29:26 ******/
/****** Object:  Default [DF_Session_CreateDate]    Script Date: 01/17/2012 12:44:41 ******/
ALTER TABLE [Security].[Session] ADD  CONSTRAINT [DF_Session_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]










