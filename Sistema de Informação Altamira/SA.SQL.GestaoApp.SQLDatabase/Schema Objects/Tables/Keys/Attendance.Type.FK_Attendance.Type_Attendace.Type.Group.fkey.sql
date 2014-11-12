/****** Object:  ForeignKey [FK_Attendance.Type_Attendace.Type.Group]    Script Date: 09/21/2011 17:29:25 ******/
/****** Object:  ForeignKey [FK_Attendance.Type_Attendace.Type.Group]    Script Date: 09/21/2011 19:10:57 ******/
/****** Object:  ForeignKey [FK_Attendance.Type_Attendace.Type.Group]    Script Date: 01/17/2012 12:44:45 ******/
ALTER TABLE [Attendance].[Type]  ADD  CONSTRAINT [FK_Attendance.Type_Attendace.Type.Group] FOREIGN KEY([Type.Group.Id])
REFERENCES [Attendance].[Type.Group] ([Id])













/*GO
ALTER TABLE [Attendance].[Type] CHECK CONSTRAINT [FK_Attendance.Type_Attendace.Type.Group]*/



