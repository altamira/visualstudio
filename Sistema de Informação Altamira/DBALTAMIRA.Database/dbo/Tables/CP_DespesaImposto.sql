CREATE TABLE [dbo].[CP_DespesaImposto] (
    [cpdi_Sequencia]   INT           NOT NULL,
    [cpdi_TipoConta]   CHAR (1)      NOT NULL,
    [cpdi_CodigoConta] SMALLINT      NOT NULL,
    [cpdi_DataEmissao] SMALLDATETIME NOT NULL,
    [cpdi_ValorTotal]  MONEY         NOT NULL,
    [cpdi_Parcelas]    SMALLINT      NOT NULL,
    [cpdi_Periodo]     VARCHAR (30)  NULL,
    [cpdi_Lock]        BINARY (8)    NULL
);

