/****** Object:  Default [DF_Log_Guid]    Script Date: 09/21/2011 17:29:26 ******/
/****** Object:  Default [DF_Log_Guid]    Script Date: 01/17/2012 12:44:45 ******/
ALTER TABLE [SMS].[Log] ADD  CONSTRAINT [DF_Log_Guid]  DEFAULT (newid()) FOR [Guid]










