CREATE TABLE [dbo].[Ordem_Separacao_Item] (
    [cd_ordem_separacao]     INT          NOT NULL,
    [cd_item_ordem]          INT          NOT NULL,
    [cd_produto]             INT          NULL,
    [qt_item_ordem]          FLOAT (53)   NULL,
    [qt_item_ordem_separada] FLOAT (53)   NULL,
    [nm_obs_item_ordem]      VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Ordem_Separacao_Item] PRIMARY KEY CLUSTERED ([cd_ordem_separacao] ASC, [cd_item_ordem] ASC) WITH (FILLFACTOR = 90)
);

