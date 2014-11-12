CREATE TABLE [dbo].[Operacao_Fiscal_Contabilizacao] (
    [cd_operacao_fiscal]       INT          NOT NULL,
    [cd_item_contab_op_fiscal] INT          NOT NULL,
    [cd_tipo_mercado]          INT          NULL,
    [cd_tipo_contabilizacao]   INT          NULL,
    [cd_lancamento_padrao]     INT          NULL,
    [nm_obs_contab_op_fiscal]  VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Operacao_Fiscal_Contabilizacao] PRIMARY KEY CLUSTERED ([cd_operacao_fiscal] ASC, [cd_item_contab_op_fiscal] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Operacao_Fiscal_Contabilizacao_Tipo_Contabilizacao] FOREIGN KEY ([cd_tipo_contabilizacao]) REFERENCES [dbo].[Tipo_Contabilizacao] ([cd_tipo_contabilizacao]),
    CONSTRAINT [FK_Operacao_Fiscal_Contabilizacao_Tipo_Mercado] FOREIGN KEY ([cd_tipo_mercado]) REFERENCES [dbo].[Tipo_Mercado] ([cd_tipo_mercado])
);

