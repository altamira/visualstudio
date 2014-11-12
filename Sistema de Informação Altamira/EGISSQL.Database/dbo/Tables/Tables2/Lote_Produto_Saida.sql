CREATE TABLE [dbo].[Lote_Produto_Saida] (
    [cd_produto]            INT        NOT NULL,
    [qt_lote_saida]         FLOAT (53) NULL,
    [cd_usuario]            INT        NULL,
    [dt_usuario]            DATETIME   NULL,
    [cd_peca_item_lote]     INT        NOT NULL,
    [cd_loja]               INT        NOT NULL,
    [cd_movimento_estoque]  INT        NULL,
    [cd_lote_produto_saida] INT        NOT NULL,
    [cd_lote_produto]       INT        NOT NULL,
    [cd_nota_saida]         INT        NULL,
    [cd_item_nota_saida]    INT        NULL,
    [cd_fase_produto]       INT        NOT NULL,
    CONSTRAINT [PK_Lote_Produto_Saida] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_peca_item_lote] ASC, [cd_loja] ASC, [cd_lote_produto_saida] ASC, [cd_lote_produto] ASC, [cd_fase_produto] ASC) WITH (FILLFACTOR = 90)
);

