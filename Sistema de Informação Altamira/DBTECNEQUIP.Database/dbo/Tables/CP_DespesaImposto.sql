CREATE TABLE [dbo].[CP_DespesaImposto] (
    [cpdi_Sequencia]   INT           NOT NULL,
    [cpdi_TipoConta]   CHAR (1)      NOT NULL,
    [cpdi_CodigoConta] SMALLINT      NOT NULL,
    [cpdi_DataEmissao] SMALLDATETIME CONSTRAINT [DF_CP_DespesaImposto_cpdi_DataEmissao] DEFAULT (NULL) NOT NULL,
    [cpdi_ValorTotal]  MONEY         NOT NULL,
    [cpdi_Parcelas]    SMALLINT      NOT NULL,
    [cpdi_Periodo]     VARCHAR (30)  NULL,
    [cpdi_Lock]        ROWVERSION    NOT NULL
);

