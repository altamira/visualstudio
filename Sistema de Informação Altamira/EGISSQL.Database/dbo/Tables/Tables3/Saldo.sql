CREATE TABLE [dbo].[Saldo] (
    [cd_plano_financeiro]       INT        NOT NULL,
    [dt_saldo_plano_financeiro] DATETIME   NOT NULL,
    [vl_saldo_inicial]          FLOAT (53) NULL,
    [cd_tipo_operacao_inicial]  INT        NULL,
    [vl_saldo_final]            FLOAT (53) NULL,
    [cd_tipo_operacao_final]    INT        NULL,
    [vl_entrada]                FLOAT (53) NULL,
    [vl_saida]                  FLOAT (53) NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL
);

