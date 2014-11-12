CREATE TABLE [dbo].[Processo_Exportacao_Item] (
    [cd_processo_exportacao]    INT          NOT NULL,
    [cd_item_processo]          INT          NOT NULL,
    [cd_pedido_venda]           INT          NULL,
    [cd_item_pedido_venda]      INT          NULL,
    [cd_tipo_embalagem]         INT          NULL,
    [qt_item_processo]          FLOAT (53)   NULL,
    [cd_produto]                INT          NULL,
    [nm_produto_processo]       VARCHAR (40) NULL,
    [qt_item_pesliq_processo]   FLOAT (53)   NULL,
    [qt_item_pesbruto_processo] FLOAT (53)   NULL,
    [nm_item_obs_processo]      VARCHAR (40) NULL,
    [dt_item_cancelamento]      DATETIME     NULL,
    [dt_item_prev_embarque]     DATETIME     NULL,
    [qt_item_embarque]          FLOAT (53)   NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Processo_Exportacao_Item] PRIMARY KEY CLUSTERED ([cd_processo_exportacao] ASC, [cd_item_processo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Exportacao_Item_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

