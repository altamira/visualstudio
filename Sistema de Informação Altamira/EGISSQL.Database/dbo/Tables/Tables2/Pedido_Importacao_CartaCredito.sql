CREATE TABLE [dbo].[Pedido_Importacao_CartaCredito] (
    [cd_pedido_importacao]      INT          NOT NULL,
    [nm_cartacredito_ped_impor] VARCHAR (20) NOT NULL,
    [cd_banco]                  INT          NOT NULL,
    [dt_cartacredito_ped_imp]   DATETIME     NOT NULL,
    [dt_solicit_cartacredito]   DATETIME     NOT NULL,
    [dt_envio_fornecedor_carta] DATETIME     NOT NULL,
    [dt_receb_fornecedor_carta] DATETIME     NOT NULL,
    [ds_cartacredito_pedido]    TEXT         NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    [cd_cartacredito_pedido]    INT          NOT NULL,
    CONSTRAINT [PK_Pedido_Importacao_CartaCredito] PRIMARY KEY CLUSTERED ([cd_pedido_importacao] ASC, [cd_cartacredito_pedido] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Pedido_Importacao_CartaCredito_Banco] FOREIGN KEY ([cd_banco]) REFERENCES [dbo].[Banco] ([cd_banco])
);

