CREATE TABLE [dbo].[Processo_Producao_Embalagem] (
    [cd_processo]               INT        NOT NULL,
    [cd_tipo_embalagem]         INT        NOT NULL,
    [cd_produto_embalagem]      INT        NOT NULL,
    [cd_produto]                INT        NULL,
    [qt_programada]             FLOAT (53) NULL,
    [qt_real_embalada]          FLOAT (53) NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    [cd_pedido_venda]           INT        NULL,
    [cd_item_pedido_venda]      INT        NULL,
    [cd_movimento_estoque_emb]  INT        NULL,
    [cd_movimento_estoque_prod] INT        NULL,
    [cd_fase_produto]           INT        NULL,
    [cd_fase_produto_emb]       INT        NULL,
    [dt_validade_produto]       DATETIME   NULL,
    CONSTRAINT [PK_Processo_Producao_Embalagem] PRIMARY KEY CLUSTERED ([cd_processo] ASC, [cd_tipo_embalagem] ASC, [cd_produto_embalagem] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Producao_Embalagem_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

