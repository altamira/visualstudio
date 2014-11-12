CREATE TABLE [dbo].[Valor_Moeda] (
    [cd_moeda]                INT          NOT NULL,
    [dt_moeda]                DATETIME     NOT NULL,
    [vl_moeda]                FLOAT (53)   NULL,
    [cd_usuario]              INT          NOT NULL,
    [dt_usuario]              DATETIME     NOT NULL,
    [vl_moeda_fiscal]         FLOAT (53)   NULL,
    [nm_obs_valor_moeda]      VARCHAR (30) NULL,
    [vl_cambio_pedido_compra] FLOAT (53)   NULL,
    CONSTRAINT [PK_Valor_moeda] PRIMARY KEY CLUSTERED ([cd_moeda] ASC, [dt_moeda] ASC) WITH (FILLFACTOR = 90)
);

