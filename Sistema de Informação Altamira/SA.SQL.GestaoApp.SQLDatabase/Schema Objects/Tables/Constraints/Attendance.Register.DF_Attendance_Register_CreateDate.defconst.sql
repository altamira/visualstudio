/****** Object:  Default [DF_Attendance_Register_CreateDate]    Script Date: 09/21/2011 17:29:25 ******/
/****** Object:  Default [DF_Attendance_Register_CreateDate]    Script Date: 01/17/2012 12:44:46 ******/
ALTER TABLE [Attendance].[Register] ADD  CONSTRAINT [DF_Attendance_Register_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]





