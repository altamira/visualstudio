CREATE TABLE [dbo].[Pedido_Venda_Transporte] (
    [cd_pedido_venda]          INT          NOT NULL,
    [cd_veiculo]               INT          NULL,
    [cd_motorista]             INT          NULL,
    [nm_obs_pedido_transporte] VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Pedido_Venda_Transporte] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Pedido_Venda_Transporte_Motorista] FOREIGN KEY ([cd_motorista]) REFERENCES [dbo].[Motorista] ([cd_motorista])
);

