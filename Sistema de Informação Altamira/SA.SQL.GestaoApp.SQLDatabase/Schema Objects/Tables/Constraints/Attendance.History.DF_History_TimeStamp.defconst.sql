/****** Object:  Default [DF_History_TimeStamp]    Script Date: 09/12/2011 14:41:55 ******/
/****** Object:  Default [DF_History_TimeStamp]    Script Date: 09/21/2011 17:29:25 ******/
/****** Object:  Default [DF_History_TimeStamp]    Script Date: 01/17/2012 12:44:46 ******/
ALTER TABLE [Attendance].[History] ADD  CONSTRAINT [DF_History_TimeStamp]  DEFAULT (getdate()) FOR [TimeStamp]













