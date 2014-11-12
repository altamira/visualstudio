CREATE TABLE [dbo].[Menu_Iso] (
    [cd_menu]               INT           NOT NULL,
    [cd_menu_iso]           INT           NOT NULL,
    [dt_menu_iso]           DATETIME      NULL,
    [nm_documento_menu_iso] VARCHAR (100) NULL,
    [nm_menu_iso]           VARCHAR (40)  NULL,
    [ic_ativo_menu_iso]     CHAR (1)      NULL,
    [nm_obs_menu_iso]       VARCHAR (40)  NULL,
    [cd_usuario]            INT           NULL,
    [dt_usuario]            DATETIME      NULL,
    CONSTRAINT [PK_Menu_Iso] PRIMARY KEY CLUSTERED ([cd_menu] ASC, [cd_menu_iso] ASC) WITH (FILLFACTOR = 90)
);

