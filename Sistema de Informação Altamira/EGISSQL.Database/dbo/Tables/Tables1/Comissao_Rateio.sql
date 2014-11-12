CREATE TABLE [dbo].[Comissao_Rateio] (
    [cd_comissao_rateio] INT        NOT NULL,
    [cd_pedido_venda]    INT        NOT NULL,
    [cd_vendedor]        INT        NULL,
    [pc_comissao_rateio] FLOAT (53) NULL,
    [vl_comissao_rateio] MONEY      NULL,
    [cd_usuario]         INT        NULL,
    [dt_usuario]         DATETIME   NULL,
    CONSTRAINT [PK_Comissao_Rateio] PRIMARY KEY CLUSTERED ([cd_comissao_rateio] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Comissao_Rateio_Pedido_Venda] FOREIGN KEY ([cd_pedido_venda]) REFERENCES [dbo].[Pedido_Venda] ([cd_pedido_venda]),
    CONSTRAINT [FK_Comissao_Rateio_Vendedor] FOREIGN KEY ([cd_vendedor]) REFERENCES [dbo].[Vendedor] ([cd_vendedor])
);

