/****** Object:  ForeignKey [FK_Attendance.Status_Attendance.Status.Group]    Script Date: 09/21/2011 17:29:25 ******/
/****** Object:  ForeignKey [FK_Attendance.Status_Attendance.Status.Group]    Script Date: 09/21/2011 19:10:57 ******/
/****** Object:  ForeignKey [FK_Attendance.Status_Attendance.Status.Group]    Script Date: 01/17/2012 12:44:45 ******/
ALTER TABLE [Attendance].[Status] ADD  CONSTRAINT [FK_Attendance.Status_Attendance.Status.Group] FOREIGN KEY([Status.Group.Id])
REFERENCES [Attendance].[Status.Group] ([Id])














/*GO
ALTER TABLE [Attendance].[Status] CHECK CONSTRAINT [FK_Attendance.Status_Attendance.Status.Group]*/





