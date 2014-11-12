CREATE TABLE [dbo].[Menu_Requisito] (
    [cd_menu]                INT          NOT NULL,
    [cd_item_menu_requisito] INT          NOT NULL,
    [cd_menu_requisito]      INT          NULL,
    [cd_tabsheet]            INT          NULL,
    [ic_menu_obrigatorio]    CHAR (1)     NULL,
    [nm_obs_menu_requisito]  VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Menu_Requisito] PRIMARY KEY CLUSTERED ([cd_menu] ASC, [cd_item_menu_requisito] ASC) WITH (FILLFACTOR = 90)
);

