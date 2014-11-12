/****** Object:  ForeignKey [FK_Attendance.History_Attendance.Register]    Script Date: 09/12/2011 14:41:55 ******/
/****** Object:  ForeignKey [FK_Attendance.History_Attendance.Register]    Script Date: 09/21/2011 17:29:25 ******/
/****** Object:  ForeignKey [FK_Attendance.History_Attendance.Register]    Script Date: 01/17/2012 12:44:46 ******/
ALTER TABLE [Attendance].[History]  ADD  CONSTRAINT [FK_Attendance.History_Attendance.Register] FOREIGN KEY([Attendance.Register.Id])
REFERENCES [Attendance].[Register] ([Id])











GO
ALTER TABLE [Attendance].[History] CHECK CONSTRAINT [FK_Attendance.History_Attendance.Register]



