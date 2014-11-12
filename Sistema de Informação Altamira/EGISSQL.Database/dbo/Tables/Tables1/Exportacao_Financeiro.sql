CREATE TABLE [dbo].[Exportacao_Financeiro] (
    [cd_empresa]               INT          NOT NULL,
    [cd_item_parametro]        INT          NOT NULL,
    [ic_tipo_atualizacao]      CHAR (1)     NULL,
    [cd_plano_financeiro]      INT          NULL,
    [cd_lancamento_padrao]     INT          NULL,
    [ic_convesao_moeda]        CHAR (1)     NULL,
    [cd_historico_financeiro]  INT          NULL,
    [cd_banco]                 INT          NULL,
    [nm_obs_exportacao]        VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_tipo_lancamento_fluxo] INT          NULL,
    [cd_tipo_operacao]         INT          NULL,
    CONSTRAINT [PK_Exportacao_Financeiro] PRIMARY KEY CLUSTERED ([cd_empresa] ASC, [cd_item_parametro] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Exportacao_Financeiro_Banco] FOREIGN KEY ([cd_banco]) REFERENCES [dbo].[Banco] ([cd_banco]),
    CONSTRAINT [FK_Exportacao_Financeiro_Tipo_Lancamento_Fluxo] FOREIGN KEY ([cd_tipo_lancamento_fluxo]) REFERENCES [dbo].[Tipo_Lancamento_Fluxo] ([cd_tipo_lancamento_fluxo]),
    CONSTRAINT [FK_Exportacao_Financeiro_Tipo_Operacao_Financeira] FOREIGN KEY ([cd_tipo_operacao]) REFERENCES [dbo].[Tipo_Operacao_Financeira] ([cd_tipo_operacao])
);

