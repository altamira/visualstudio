/*
ALTER TABLE [Location].[State]
    ADD CONSTRAINT [FK_Location.State_Location.City] FOREIGN KEY ([Location.CityCapital.Id]) REFERENCES [Location].[City] ([Id]) ON DELETE NO ACTION ON UPDATE NO ACTION;
*/

