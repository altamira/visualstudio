CREATE TABLE [dbo].[Dipi_Classificacao_Fiscal] (
    [cd_ano]                  INT        NOT NULL,
    [cd_classificacao_fiscal] INT        NOT NULL,
    [ic_tipo_ipi]             CHAR (1)   NULL,
    [vl_classif_fiscal_dipi]  FLOAT (53) NULL,
    [cd_usuario]              INT        NULL,
    [dt_usuario]              DATETIME   NULL,
    CONSTRAINT [PK_Dipi_Classificacao_Fiscal] PRIMARY KEY CLUSTERED ([cd_ano] ASC, [cd_classificacao_fiscal] ASC) WITH (FILLFACTOR = 90)
);

