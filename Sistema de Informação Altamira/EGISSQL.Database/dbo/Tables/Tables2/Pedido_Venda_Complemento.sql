CREATE TABLE [dbo].[Pedido_Venda_Complemento] (
    [cd_pedido_venda]         INT      NOT NULL,
    [cd_motivo_reprogramacao] INT      NULL,
    [cd_usuario]              INT      NULL,
    [dt_usuario]              DATETIME NULL,
    [cd_item_pedido_venda]    INT      NULL,
    CONSTRAINT [PK_Pedido_Venda_Complemento] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Pedido_Venda_Complemento_Motivo_Reprogramacao] FOREIGN KEY ([cd_motivo_reprogramacao]) REFERENCES [dbo].[Motivo_Reprogramacao] ([cd_motivo_reprogramacao])
);

