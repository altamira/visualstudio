CREATE TABLE [dbo].[Plano_Financeiro_Saldo] (
    [cd_plano_financeiro]       INT        NOT NULL,
    [dt_saldo_plano_financeiro] DATETIME   NOT NULL,
    [cd_tipo_lancamento_fluxo]  INT        NOT NULL,
    [vl_saldo_inicial]          FLOAT (53) NULL,
    [cd_tipo_operacao_inicial]  INT        NULL,
    [vl_saldo_final]            FLOAT (53) NULL,
    [cd_tipo_operacao_final]    INT        NULL,
    [vl_entrada]                FLOAT (53) NULL,
    [vl_saida]                  FLOAT (53) NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    CONSTRAINT [PK_Plano_Financeiro_Saldo] PRIMARY KEY CLUSTERED ([cd_plano_financeiro] ASC, [dt_saldo_plano_financeiro] ASC, [cd_tipo_lancamento_fluxo] ASC) WITH (FILLFACTOR = 90)
);

