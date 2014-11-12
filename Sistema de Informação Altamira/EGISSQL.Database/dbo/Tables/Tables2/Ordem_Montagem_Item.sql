CREATE TABLE [dbo].[Ordem_Montagem_Item] (
    [cd_ordem_montagem]      INT          NULL,
    [cd_item_ordem_montagem] INT          NULL,
    [qt_ordem_montagem]      FLOAT (53)   NULL,
    [cd_produto]             INT          NULL,
    [nm_obs_ordem_montagem]  VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [nm_das_ordem_montagem]  VARCHAR (40) NULL,
    [nm_fantasia_produto]    VARCHAR (15) NULL
);

