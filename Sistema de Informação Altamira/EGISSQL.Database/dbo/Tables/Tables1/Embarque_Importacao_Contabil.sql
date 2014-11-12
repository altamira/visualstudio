CREATE TABLE [dbo].[Embarque_Importacao_Contabil] (
    [cd_pedido_importacao] INT          NOT NULL,
    [cd_embarque]          INT          NOT NULL,
    [cd_item_contabil]     INT          NOT NULL,
    [vl_contabil_pedido]   FLOAT (53)   NULL,
    [dt_contabil_pedido]   DATETIME     NULL,
    [cd_lancamento_padrao] INT          NULL,
    [nm_compl_historico]   VARCHAR (40) NULL,
    [nm_obs_contabil]      VARCHAR (40) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Embarque_Importacao_Contabil] PRIMARY KEY CLUSTERED ([cd_pedido_importacao] ASC, [cd_embarque] ASC, [cd_item_contabil] ASC) WITH (FILLFACTOR = 90)
);

