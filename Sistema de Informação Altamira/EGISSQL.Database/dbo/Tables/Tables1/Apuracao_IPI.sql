CREATE TABLE [dbo].[Apuracao_IPI] (
    [cd_apuracao_ipi]        INT          NOT NULL,
    [dt_inicio_apuracao_ipi] DATETIME     NULL,
    [dt_final_apuracao_ipi]  DATETIME     NULL,
    [vl_debito_ipi]          FLOAT (53)   NULL,
    [vl_debito_outros]       FLOAT (53)   NULL,
    [nm_debito_outros]       VARCHAR (50) NULL,
    [vl_debito_estorno]      FLOAT (53)   NULL,
    [nm_debito_estorno]      VARCHAR (50) NULL,
    [vl_credito_ipi]         FLOAT (53)   NULL,
    [vl_credito_outros]      FLOAT (53)   NULL,
    [nm_credito_outros]      VARCHAR (50) NULL,
    [vl_credito_estorno]     FLOAT (53)   NULL,
    [nm_credito_estorno]     VARCHAR (50) NULL,
    [vl_deducao_ipi]         FLOAT (53)   NULL,
    [nm_deducao_ipi]         VARCHAR (50) NULL,
    [vl_saldo_anterior]      FLOAT (53)   NULL,
    CONSTRAINT [PK_Apuracao_IPI] PRIMARY KEY CLUSTERED ([cd_apuracao_ipi] ASC) WITH (FILLFACTOR = 90)
);

