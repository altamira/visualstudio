CREATE TABLE [dbo].[Processo_Producao_Pedido] (
    [cd_processo]          INT        NOT NULL,
    [cd_pedido_venda]      INT        NOT NULL,
    [qt_pedido_processo]   FLOAT (53) NULL,
    [cd_usuario]           INT        NULL,
    [dt_usuario]           DATETIME   NULL,
    [cd_item_pedido_venda] INT        NOT NULL,
    CONSTRAINT [PK_Processo_Producao_Pedido] PRIMARY KEY CLUSTERED ([cd_processo] ASC, [cd_pedido_venda] ASC, [cd_item_pedido_venda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Producao_Pedido_Pedido_Venda] FOREIGN KEY ([cd_pedido_venda]) REFERENCES [dbo].[Pedido_Venda] ([cd_pedido_venda])
);

