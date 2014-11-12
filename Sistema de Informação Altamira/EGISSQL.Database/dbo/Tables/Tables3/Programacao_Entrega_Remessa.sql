CREATE TABLE [dbo].[Programacao_Entrega_Remessa] (
    [cd_remessa]             INT        NOT NULL,
    [cd_programacao_entrega] INT        NULL,
    [cd_produto]             INT        NULL,
    [qt_remessa_produto]     FLOAT (53) NULL,
    [dt_remessa_produto]     DATETIME   NULL,
    [cd_usuario]             INT        NULL,
    [dt_usuario]             DATETIME   NULL,
    [cd_pedido_venda]        INT        NULL,
    [cd_item_pedido_venda]   INT        NULL,
    [cd_previa_faturamento]  INT        NULL,
    CONSTRAINT [PK_Programacao_Entrega_Remessa] PRIMARY KEY CLUSTERED ([cd_remessa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Programacao_Entrega_Remessa_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

