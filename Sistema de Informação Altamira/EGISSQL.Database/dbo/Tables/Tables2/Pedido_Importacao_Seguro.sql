CREATE TABLE [dbo].[Pedido_Importacao_Seguro] (
    [cd_pedido_importacao]     INT          NOT NULL,
    [cd_tipo_seguro]           INT          NULL,
    [cd_moeda]                 INT          NULL,
    [nm_seg_prov_ped_imp]      VARCHAR (30) NULL,
    [vl_seguro_int_pedido_imp] FLOAT (53)   NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_seguradora]            INT          NULL,
    [dt_cotacao_seguro]        DATETIME     NULL,
    [vl_moeda_seguro]          FLOAT (53)   NULL,
    CONSTRAINT [PK_Pedido_Importacao_Seguro] PRIMARY KEY CLUSTERED ([cd_pedido_importacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Pedido_Importacao_Seguro_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda]),
    CONSTRAINT [FK_Pedido_Importacao_Seguro_Tipo_Seguro] FOREIGN KEY ([cd_tipo_seguro]) REFERENCES [dbo].[Tipo_Seguro] ([cd_tipo_seguro])
);

