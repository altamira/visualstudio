CREATE TABLE [dbo].[Pedido_Venda_Documento] (
    [cd_pedido_venda]           INT           NOT NULL,
    [cd_pedido_venda_documento] INT           NOT NULL,
    [nm_pedido_venda_documento] VARCHAR (50)  NULL,
    [dt_pedido_venda_documento] DATETIME      NULL,
    [nm_caminho_documento]      VARCHAR (200) NULL,
    [ds_pedido_venda_documento] TEXT          NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    CONSTRAINT [PK_Pedido_Venda_Documento] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC, [cd_pedido_venda_documento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Pedido_Venda_Documento_Pedido_Venda] FOREIGN KEY ([cd_pedido_venda]) REFERENCES [dbo].[Pedido_Venda] ([cd_pedido_venda]) NOT FOR REPLICATION
);

