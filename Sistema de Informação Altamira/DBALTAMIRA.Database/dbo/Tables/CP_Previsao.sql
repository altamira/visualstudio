CREATE TABLE [dbo].[CP_Previsao] (
    [cppr_Sequencia]      INT           NOT NULL,
    [cppr_Tipo]           CHAR (1)      NOT NULL,
    [cppr_Descricao]      SMALLINT      NULL,
    [cppr_Fornecedor]     CHAR (14)     NULL,
    [cppr_Parcela]        CHAR (7)      NOT NULL,
    [cppr_DataVencimento] SMALLDATETIME NOT NULL,
    [cppr_Valor]          MONEY         NOT NULL,
    [cppr_Observacao]     VARCHAR (40)  NULL,
    [cppr_Valida]         SMALLINT      NULL,
    [cppr_Lock]           BINARY (8)    NULL
);

