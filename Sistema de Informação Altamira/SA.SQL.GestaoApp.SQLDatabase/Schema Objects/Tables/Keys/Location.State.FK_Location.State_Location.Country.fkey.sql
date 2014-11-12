
/****** Object:  ForeignKey [FK_Location.State_Location.Country]    Script Date: 09/21/2011 17:29:26 ******/
/****** Object:  ForeignKey [FK_Location.State_Location.Country]    Script Date: 01/17/2012 12:44:45 ******/
ALTER TABLE [Location].[State]  ADD  CONSTRAINT [FK_Location.State_Location.Country] FOREIGN KEY([Location.Country.Id])
REFERENCES [Location].[Country] ([Id])











GO
ALTER TABLE [Location].[State] NOCHECK CONSTRAINT [FK_Location.State_Location.Country]




GO
/*ALTER TABLE [Location].[State] NOCHECK CONSTRAINT [FK_Location.State_Location.Country];*/

