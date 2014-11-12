CREATE TABLE [dbo].[Menu_Site_ACS] (
    [cd_menu]       INT           NOT NULL,
    [nm_menu]       VARCHAR (60)  NULL,
    [qt_ordem_menu] INT           NULL,
    [nm_link_menu]  VARCHAR (100) NULL,
    [ds_menu]       TEXT          NULL,
    [cd_usuario]    INT           NULL,
    [dt_usuario]    DATETIME      NULL,
    [cd_idioma]     INT           NULL,
    [ic_ativo_menu] CHAR (1)      NULL,
    CONSTRAINT [PK_Menu_Site_ACS] PRIMARY KEY CLUSTERED ([cd_menu] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Menu_Site_ACS_Idioma] FOREIGN KEY ([cd_idioma]) REFERENCES [dbo].[Idioma] ([cd_idioma])
);

