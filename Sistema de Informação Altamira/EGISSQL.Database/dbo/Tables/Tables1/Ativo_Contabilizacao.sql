CREATE TABLE [dbo].[Ativo_Contabilizacao] (
    [cd_ativo_contabilizacao] INT          NOT NULL,
    [dt_ativo_contabilizacao] DATETIME     NULL,
    [cd_lancamento_padrao]    INT          NULL,
    [cd_conta_debito]         INT          NULL,
    [cd_conta_credito]        INT          NULL,
    [cd_historico_contabil]   INT          NULL,
    [nm_historico_ativo]      VARCHAR (40) NULL,
    [vl_ativo_contabilizacao] FLOAT (53)   NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [nm_complemento_ativo]    VARCHAR (40) NULL,
    [cd_centro_custo]         INT          NULL,
    CONSTRAINT [PK_Ativo_Contabilizacao] PRIMARY KEY CLUSTERED ([cd_ativo_contabilizacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Ativo_Contabilizacao_Lancamento_Padrao] FOREIGN KEY ([cd_lancamento_padrao]) REFERENCES [dbo].[Lancamento_Padrao] ([cd_lancamento_padrao])
);

