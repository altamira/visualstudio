CREATE TABLE [dbo].[OM_Devolucao] (
    [cd_om]                    INT          NULL,
    [cd_item_om_devolucao]     INT          NULL,
    [qt_item_om_devolucao]     FLOAT (53)   NULL,
    [cd_produto]               INT          NULL,
    [nm_obs_item_om_devolucao] VARCHAR (30) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL
);

