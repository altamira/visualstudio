CREATE TABLE [dbo].[Caixa_Saldo] (
    [dt_saldo_caixa]           DATETIME   NOT NULL,
    [cd_tipo_caixa]            INT        NOT NULL,
    [cd_plano_financeiro]      INT        NULL,
    [vl_saldo_inicial_caixa]   FLOAT (53) NULL,
    [cd_tipo_operacao_inicial] INT        NULL,
    [vl_entrada]               FLOAT (53) NULL,
    [vl_saida]                 FLOAT (53) NULL,
    [vl_saldo_final_caixa]     FLOAT (53) NULL,
    [cd_tipo_operacao_final]   INT        NULL,
    [cd_moeda]                 INT        NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    [ic_manual_caixa_saldo]    CHAR (1)   NULL,
    [ic_saldo_inicial]         CHAR (1)   NULL,
    [ic_saldo_final_caixa]     CHAR (1)   NULL,
    [vl_saida_caixa]           FLOAT (53) NULL,
    [vl_entrada_caixa]         FLOAT (53) NULL,
    [dt_cotacao_moeda]         DATETIME   NULL,
    [vl_moeda_caixa_saldo]     FLOAT (53) NULL,
    [vl_cotacao_moeda]         FLOAT (53) NULL,
    CONSTRAINT [PK_Caixa_Saldo] PRIMARY KEY CLUSTERED ([dt_saldo_caixa] ASC, [cd_tipo_caixa] ASC) WITH (FILLFACTOR = 90)
);

