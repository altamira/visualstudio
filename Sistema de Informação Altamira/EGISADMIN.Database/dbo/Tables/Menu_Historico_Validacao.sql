CREATE TABLE [dbo].[Menu_Historico_Validacao] (
    [cd_menu_historico]         INT          NOT NULL,
    [cd_item_validacao]         INT          NOT NULL,
    [cd_tabela]                 INT          NULL,
    [cd_atributo]               INT          NULL,
    [ds_validacao_atributo]     TEXT         NULL,
    [nm_obs_validacao_atributo] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Menu_Historico_Validacao] PRIMARY KEY CLUSTERED ([cd_menu_historico] ASC, [cd_item_validacao] ASC) WITH (FILLFACTOR = 90)
);

