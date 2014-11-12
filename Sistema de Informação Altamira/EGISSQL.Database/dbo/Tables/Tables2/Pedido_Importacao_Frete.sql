CREATE TABLE [dbo].[Pedido_Importacao_Frete] (
    [cd_pedido_importacao]  INT        NOT NULL,
    [cd_tipo_frete]         INT        NULL,
    [cd_moeda]              INT        NULL,
    [vl_frete_int_ped_imp]  FLOAT (53) NULL,
    [vl_desp_frete_ped_imp] FLOAT (53) NULL,
    [cd_usuario]            INT        NULL,
    [dt_usuario]            DATETIME   NULL,
    CONSTRAINT [PK_Pedido_Importacao_Frete] PRIMARY KEY CLUSTERED ([cd_pedido_importacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Pedido_Importacao_Frete_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda])
);

