CREATE TABLE [dbo].[Comissao_Fixa] (
    [cd_comissao_fixa]     INT          NOT NULL,
    [cd_pedido_venda]      INT          NULL,
    [cd_vendedor]          INT          NULL,
    [pc_comissao_fixa]     FLOAT (53)   NULL,
    [vl_comissao_fixa]     MONEY        NULL,
    [nm_obs_comissao_fixa] VARCHAR (40) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Comissao_Fixa] PRIMARY KEY CLUSTERED ([cd_comissao_fixa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Comissao_Fixa_Pedido_Venda] FOREIGN KEY ([cd_pedido_venda]) REFERENCES [dbo].[Pedido_Venda] ([cd_pedido_venda]),
    CONSTRAINT [FK_Comissao_Fixa_Vendedor] FOREIGN KEY ([cd_vendedor]) REFERENCES [dbo].[Vendedor] ([cd_vendedor])
);

