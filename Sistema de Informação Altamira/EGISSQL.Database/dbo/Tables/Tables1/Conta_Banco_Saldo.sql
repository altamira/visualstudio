CREATE TABLE [dbo].[Conta_Banco_Saldo] (
    [cd_conta_banco]               INT        NOT NULL,
    [dt_saldo_conta_banco]         DATETIME   NOT NULL,
    [cd_tipo_lancamento_fluxo]     INT        NOT NULL,
    [vl_saldo_inicial_conta_banco] FLOAT (53) NULL,
    [cd_tipo_operacao_inicial]     INT        NULL,
    [vl_saldo_final_conta_banco]   FLOAT (53) NULL,
    [cd_tipo_operacao_final]       INT        NULL,
    [vl_entrada_conta_banco]       FLOAT (53) NULL,
    [vl_saida_conta_banco]         FLOAT (53) NULL,
    [cd_usuario]                   INT        NULL,
    [dt_usuario]                   DATETIME   NULL,
    [cd_plano_financeiro]          INT        NULL,
    [cd_moeda]                     INT        NULL,
    [ic_fixo_saldo_banco]          CHAR (1)   NULL,
    CONSTRAINT [PK_Conta_Banco_Saldo] PRIMARY KEY CLUSTERED ([cd_conta_banco] ASC, [dt_saldo_conta_banco] ASC, [cd_tipo_lancamento_fluxo] ASC) WITH (FILLFACTOR = 90)
);

