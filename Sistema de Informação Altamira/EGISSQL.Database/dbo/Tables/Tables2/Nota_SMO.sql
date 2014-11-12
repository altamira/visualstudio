CREATE TABLE [dbo].[Nota_SMO] (
    [cd_pedido_venda]      INT          NOT NULL,
    [cd_item_pedido_venda] INT          NOT NULL,
    [cd_nota_entrada]      INT          NULL,
    [cd_tipo_destinatario] INT          NULL,
    [dt_nota_entrada]      DATETIME     NULL,
    [nm_obs_nota_smo]      VARCHAR (40) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [qt_perda_nota_smo]    FLOAT (53)   NULL,
    [nm_motivo_nota_smo]   VARCHAR (40) NULL,
    [cd_fornecedor]        INT          NULL,
    [cd_operacao_fiscal]   INT          NULL,
    [cd_serie_nota_fiscal] INT          NULL,
    [cd_nota_smo]          INT          NOT NULL,
    CONSTRAINT [PK_Nota_SMO] PRIMARY KEY CLUSTERED ([cd_nota_smo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Nota_SMO_Fornecedor] FOREIGN KEY ([cd_fornecedor]) REFERENCES [dbo].[Fornecedor] ([cd_fornecedor]),
    CONSTRAINT [FK_Nota_SMO_Operacao_Fiscal] FOREIGN KEY ([cd_operacao_fiscal]) REFERENCES [dbo].[Operacao_Fiscal] ([cd_operacao_fiscal]),
    CONSTRAINT [FK_Nota_SMO_Pedido_Venda] FOREIGN KEY ([cd_pedido_venda]) REFERENCES [dbo].[Pedido_Venda] ([cd_pedido_venda]),
    CONSTRAINT [FK_Nota_SMO_Serie_Nota_Fiscal] FOREIGN KEY ([cd_serie_nota_fiscal]) REFERENCES [dbo].[Serie_Nota_Fiscal] ([cd_serie_nota_fiscal]),
    CONSTRAINT [FK_Nota_SMO_Tipo_Destinatario] FOREIGN KEY ([cd_tipo_destinatario]) REFERENCES [dbo].[Tipo_Destinatario] ([cd_tipo_destinatario])
);

