/****** Object:  Default [DF_SMS.Log_Date]    Script Date: 09/21/2011 17:29:26 ******/
/****** Object:  Default [DF_SMS.Log_Date]    Script Date: 01/17/2012 12:44:45 ******/
ALTER TABLE [SMS].[Log] ADD  CONSTRAINT [DF_SMS.Log_Date]  DEFAULT (getdate()) FOR [Date]










