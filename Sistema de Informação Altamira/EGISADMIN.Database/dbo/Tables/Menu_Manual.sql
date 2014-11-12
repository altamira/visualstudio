CREATE TABLE [dbo].[Menu_Manual] (
    [cd_menu]                INT           NOT NULL,
    [cd_menu_manual]         INT           NOT NULL,
    [dt_menu_manual]         DATETIME      NULL,
    [nm_caminho_menu_manual] VARCHAR (100) NULL,
    [ic_ativo_menu_manual]   CHAR (1)      NULL,
    [nm_obs_menu_manual]     VARCHAR (40)  NULL,
    [dt_revisao_menu_manual] DATETIME      NULL,
    [cd_usuario]             INT           NULL,
    [dt_usuario]             DATETIME      NULL,
    [ds_descricao_manual]    TEXT          NULL,
    [nm_topico_menu_manual]  VARCHAR (40)  NULL,
    CONSTRAINT [PK_Menu_Manual] PRIMARY KEY CLUSTERED ([cd_menu] ASC, [cd_menu_manual] ASC) WITH (FILLFACTOR = 90)
);

