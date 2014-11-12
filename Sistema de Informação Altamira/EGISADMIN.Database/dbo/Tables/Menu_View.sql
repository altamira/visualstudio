CREATE TABLE [dbo].[Menu_View] (
    [cd_menu]    INT      NOT NULL,
    [cd_view]    INT      NOT NULL,
    [cd_usuario] INT      NULL,
    [dt_usuario] DATETIME NULL,
    CONSTRAINT [PK_Menu_View] PRIMARY KEY CLUSTERED ([cd_menu] ASC, [cd_view] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Menu_View_View_] FOREIGN KEY ([cd_view]) REFERENCES [dbo].[View_] ([cd_view])
);

