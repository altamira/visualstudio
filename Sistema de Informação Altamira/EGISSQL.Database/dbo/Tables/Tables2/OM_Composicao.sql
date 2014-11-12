CREATE TABLE [dbo].[OM_Composicao] (
    [cd_om]          INT          NOT NULL,
    [cd_item_om]     INT          NOT NULL,
    [qt_item_om]     FLOAT (53)   NULL,
    [cd_produto]     INT          NULL,
    [nm_obs_item_om] VARCHAR (30) NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    [nm_obs_item_os] VARCHAR (30) NULL,
    CONSTRAINT [PK_OM_Composicao] PRIMARY KEY CLUSTERED ([cd_om] ASC, [cd_item_om] ASC) WITH (FILLFACTOR = 90)
);

