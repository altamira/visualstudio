CREATE TABLE [dbo].[Suprimento_Montagem_Item] (
    [cd_suprimento_montagem]       INT        NOT NULL,
    [cd_item_suprimento_montagem]  INT        NOT NULL,
    [cd_produto]                   INT        NULL,
    [qt_item_suprimento_montagem]  FLOAT (53) NULL,
    [qt_posicao_estoque]           FLOAT (53) NULL,
    [cd_movimento_estoque_entrada] INT        NULL,
    [cd_movimento_estoque_saida]   INT        NULL,
    [cd_usuario]                   INT        NULL,
    [dt_usuario]                   DATETIME   NULL,
    CONSTRAINT [PK_Suprimento_Montagem_Item] PRIMARY KEY CLUSTERED ([cd_suprimento_montagem] ASC, [cd_item_suprimento_montagem] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Suprimento_Montagem_Item_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

