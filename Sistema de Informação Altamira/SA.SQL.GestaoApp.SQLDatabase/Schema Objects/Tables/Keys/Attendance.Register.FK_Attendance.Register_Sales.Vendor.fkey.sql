
/****** Object:  ForeignKey [FK_Attendance.Register_Sales.Vendor]    Script Date: 09/16/2011 11:33:30 ******/
/****** Object:  ForeignKey [FK_Attendance.Register_Sales.Vendor]    Script Date: 09/21/2011 17:29:25 ******/
/****** Object:  ForeignKey [FK_Attendance.Register_Sales.Vendor]    Script Date: 01/17/2012 12:44:45 ******/
ALTER TABLE [Attendance].[Register]  ADD  CONSTRAINT [FK_Attendance.Register_Sales.Vendor] FOREIGN KEY([Sales.Vendor.Id])
REFERENCES [Sales].[Vendor] ([Id])














GO
ALTER TABLE [Attendance].[Register] CHECK CONSTRAINT [FK_Attendance.Register_Sales.Vendor]

