CREATE TABLE [dbo].[Movimento_Caixa_Composicao] (
    [cd_movimento_caixa]       INT        NOT NULL,
    [cd_item_movimento_caixa]  INT        NOT NULL,
    [cd_ordem]                 INT        NOT NULL,
    [cd_produto]               INT        NOT NULL,
    [qt_item_composicao_caixa] FLOAT (53) NULL,
    [vl_item_composicao_caixa] MONEY      NULL,
    [vl_produto]               MONEY      NULL,
    [pc_desc_movimento_caixa]  FLOAT (53) NULL,
    [vl_total_componente]      MONEY      NULL,
    [dt_cancel_componente]     DATETIME   NULL,
    [vl_descontado]            MONEY      NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    [cd_cor_item_composicao]   INT        NULL,
    [vl_lista_componente]      MONEY      NULL,
    CONSTRAINT [PK_Movimento_Caixa_Composicao] PRIMARY KEY CLUSTERED ([cd_movimento_caixa] ASC, [cd_item_movimento_caixa] ASC, [cd_ordem] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Movimento_Caixa_Composicao_Movimento_Caixa_Item] FOREIGN KEY ([cd_movimento_caixa], [cd_item_movimento_caixa]) REFERENCES [dbo].[Movimento_Caixa_Item] ([cd_movimento_caixa], [cd_item_movimento_caixa]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_Movimento_Caixa_Composicao_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

