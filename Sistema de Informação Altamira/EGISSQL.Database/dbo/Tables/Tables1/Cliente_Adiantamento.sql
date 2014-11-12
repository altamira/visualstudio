CREATE TABLE [dbo].[Cliente_Adiantamento] (
    [cd_cliente_adiantamento] INT          NOT NULL,
    [dt_adiantamento]         DATETIME     NULL,
    [cd_cliente]              INT          NULL,
    [cd_motivo_adiantamento]  INT          NULL,
    [vl_adiantamento]         FLOAT (53)   NULL,
    [dt_baixa_adiantamento]   DATETIME     NULL,
    [cd_usuario_baixa]        INT          NULL,
    [nm_obs_adiantamento]     VARCHAR (60) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_moeda]                INT          NULL,
    [cd_documento_receber]    INT          NULL,
    [cd_pedido_venda]         INT          NULL,
    CONSTRAINT [PK_Cliente_Adiantamento] PRIMARY KEY CLUSTERED ([cd_cliente_adiantamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Adiantamento_Documento_Receber] FOREIGN KEY ([cd_documento_receber]) REFERENCES [dbo].[Documento_Receber] ([cd_documento_receber]),
    CONSTRAINT [FK_Cliente_Adiantamento_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda]),
    CONSTRAINT [FK_Cliente_Adiantamento_Usuario] FOREIGN KEY ([cd_usuario_baixa]) REFERENCES [dbo].[Usuario] ([cd_usuario])
);

