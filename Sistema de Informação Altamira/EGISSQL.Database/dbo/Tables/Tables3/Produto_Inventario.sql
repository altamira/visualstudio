CREATE TABLE [dbo].[Produto_Inventario] (
    [cd_produto]                INT        NOT NULL,
    [qt_inventario]             FLOAT (53) NULL,
    [cd_fase_produto]           INT        NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    [cd_tipo_movimento_estoque] INT        NULL,
    [qt_saldo_atual_produto]    FLOAT (53) NULL,
    [vl_custo_inventario]       FLOAT (53) NULL,
    CONSTRAINT [PK_Produto_Inventario] PRIMARY KEY CLUSTERED ([cd_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Inventario_Tipo_Movimento_Estoque] FOREIGN KEY ([cd_tipo_movimento_estoque]) REFERENCES [dbo].[Tipo_Movimento_Estoque] ([cd_tipo_movimento_estoque])
);

