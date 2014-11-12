CREATE TABLE [dbo].[Menu_Legenda] (
    [cd_menu]    INT      NOT NULL,
    [cd_legenda] INT      NOT NULL,
    [cd_usuario] INT      NULL,
    [dt_usuario] DATETIME NULL,
    CONSTRAINT [PK_Menu_Legenda] PRIMARY KEY CLUSTERED ([cd_menu] ASC, [cd_legenda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Menu_Legenda_Legenda] FOREIGN KEY ([cd_legenda]) REFERENCES [dbo].[Legenda] ([cd_legenda])
);

