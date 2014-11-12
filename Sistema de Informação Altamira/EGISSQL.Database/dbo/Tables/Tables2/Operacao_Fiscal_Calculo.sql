CREATE TABLE [dbo].[Operacao_Fiscal_Calculo] (
    [cd_operacao_fiscal]   INT          NOT NULL,
    [ic_frete_base_icms]   CHAR (1)     NULL,
    [ic_seguro_base_icms]  CHAR (1)     NULL,
    [ic_despesa_base_icms] CHAR (1)     NULL,
    [nm_obs_calculo]       VARCHAR (40) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Operacao_Fiscal_Calculo] PRIMARY KEY CLUSTERED ([cd_operacao_fiscal] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Operacao_Fiscal_Calculo_Operacao_Fiscal] FOREIGN KEY ([cd_operacao_fiscal]) REFERENCES [dbo].[Operacao_Fiscal] ([cd_operacao_fiscal])
);

