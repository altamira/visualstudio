CREATE TABLE [dbo].[Usuario_Menu_Internet] (
    [cd_menu_internet] INT NULL,
    [cd_usuario]       INT NULL,
    CONSTRAINT [FK_Usuario_Menu_Internet_Usuario] FOREIGN KEY ([cd_usuario]) REFERENCES [dbo].[Usuario] ([cd_usuario])
);

