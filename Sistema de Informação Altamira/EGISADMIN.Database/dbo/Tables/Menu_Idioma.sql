CREATE TABLE [dbo].[Menu_Idioma] (
    [cd_menu]               INT          NOT NULL,
    [cd_idioma]             INT          NOT NULL,
    [nm_menu_idioma]        VARCHAR (40) NULL,
    [nm_titulo_menu_idioma] VARCHAR (60) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Menu_Idioma] PRIMARY KEY CLUSTERED ([cd_menu] ASC, [cd_idioma] ASC) WITH (FILLFACTOR = 90)
);

