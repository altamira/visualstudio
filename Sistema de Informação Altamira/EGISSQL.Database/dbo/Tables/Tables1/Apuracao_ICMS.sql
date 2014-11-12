CREATE TABLE [dbo].[Apuracao_ICMS] (
    [cd_apuracao_icms]        INT          NOT NULL,
    [dt_inicio_apuracao_icms] DATETIME     NULL,
    [dt_final_apuracao_icms]  DATETIME     NULL,
    [vl_debito_icms]          FLOAT (53)   NULL,
    [vl_debito_outros]        FLOAT (53)   NULL,
    [nm_debito_outros]        VARCHAR (50) NULL,
    [vl_debito_estorno]       FLOAT (53)   NULL,
    [nm_debito_estorno]       VARCHAR (50) NULL,
    [vl_credito_icms]         FLOAT (53)   NULL,
    [vl_credito_outros]       FLOAT (53)   NULL,
    [nm_credito_outros]       VARCHAR (50) NULL,
    [vl_credito_estorno]      FLOAT (53)   NULL,
    [nm_credito_estorno]      VARCHAR (50) NULL,
    [vl_deducao_icms]         FLOAT (53)   NULL,
    [nm_deducao_icms]         VARCHAR (50) NULL,
    [vl_saldo_anterior]       FLOAT (53)   NULL,
    CONSTRAINT [PK_Apuracao_ICMS] PRIMARY KEY CLUSTERED ([cd_apuracao_icms] ASC) WITH (FILLFACTOR = 90)
);

