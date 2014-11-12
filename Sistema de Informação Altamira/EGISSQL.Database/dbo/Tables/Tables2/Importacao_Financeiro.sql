CREATE TABLE [dbo].[Importacao_Financeiro] (
    [cd_empresa]              INT          NOT NULL,
    [cd_item_parametro]       INT          NOT NULL,
    [cd_plano_financeiro]     INT          NULL,
    [cd_lancamento_padrao]    INT          NULL,
    [ic_conversao_moeda]      CHAR (1)     NULL,
    [cd_banco]                INT          NULL,
    [cd_historico_financeiro] INT          NULL,
    [nm_obs_importacao]       VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [ic_tipo_atualizacao]     CHAR (1)     NULL,
    CONSTRAINT [PK_Importacao_Financeiro] PRIMARY KEY CLUSTERED ([cd_empresa] ASC, [cd_item_parametro] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Importacao_Financeiro_Historico_Financeiro] FOREIGN KEY ([cd_historico_financeiro]) REFERENCES [dbo].[Historico_Financeiro] ([cd_historico_financeiro])
);

