/****** Object:  ForeignKey [FK_Location.City_Location.State]    Script Date: 09/12/2011 14:41:55 ******/
/****** Object:  ForeignKey [FK_Location.City_Location.State]    Script Date: 09/21/2011 17:29:26 ******/
/****** Object:  ForeignKey [FK_Location.City_Location.State]    Script Date: 01/17/2012 12:44:46 ******/
ALTER TABLE [Location].[City]  ADD  CONSTRAINT [FK_Location.City_Location.State] FOREIGN KEY([Location.State.Id])
REFERENCES [Location].[State] ([Id])











GO
ALTER TABLE [Location].[City] CHECK CONSTRAINT [FK_Location.City_Location.State]



