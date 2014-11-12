CREATE TABLE [dbo].[Menu_Historico_Tabela] (
    [cd_menu_historico]   INT          NOT NULL,
    [cd_item_menu_tabela] INT          NOT NULL,
    [cd_tabela]           INT          NULL,
    [nm_obs_menu_tabela]  VARCHAR (40) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Menu_Historico_Tabela] PRIMARY KEY CLUSTERED ([cd_menu_historico] ASC, [cd_item_menu_tabela] ASC) WITH (FILLFACTOR = 90)
);

