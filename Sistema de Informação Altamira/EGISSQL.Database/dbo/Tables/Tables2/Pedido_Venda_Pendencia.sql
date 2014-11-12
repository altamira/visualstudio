CREATE TABLE [dbo].[Pedido_Venda_Pendencia] (
    [cd_pedido_venda]        INT          NOT NULL,
    [cd_tipo_pendencia]      INT          NOT NULL,
    [nm_obs_tipo_pendencia]  VARCHAR (60) NULL,
    [cd_usuario_liberacao]   INT          NULL,
    [dt_liberacao_pendencia] DATETIME     NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [cd_item_pedido_venda]   INT          NOT NULL,
    [cd_pedido_pendencia]    INT          NOT NULL,
    CONSTRAINT [PK_Pedido_Venda_Pendencia] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC, [cd_tipo_pendencia] ASC, [cd_item_pedido_venda] ASC, [cd_pedido_pendencia] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Pedido_Venda_Pendencia_Tipo_Pendencia_Financeira] FOREIGN KEY ([cd_tipo_pendencia]) REFERENCES [dbo].[Tipo_Pendencia_Financeira] ([cd_tipo_pendencia])
);

