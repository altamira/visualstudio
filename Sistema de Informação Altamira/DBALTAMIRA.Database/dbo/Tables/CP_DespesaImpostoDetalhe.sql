CREATE TABLE [dbo].[CP_DespesaImpostoDetalhe] (
    [cpdd_Sequencia]       INT           NOT NULL,
    [cpdd_Parcela]         SMALLINT      NOT NULL,
    [cpdd_DataVencimento]  SMALLDATETIME NOT NULL,
    [cpdd_DataProrrogacao] SMALLDATETIME NULL,
    [cpdd_Valor]           MONEY         NOT NULL,
    [cpdd_ValorAcrescimo]  MONEY         NOT NULL,
    [cpdd_ValorDesconto]   MONEY         NOT NULL,
    [cpdd_ValorTotal]      MONEY         NOT NULL,
    [cpdd_NumeroCheque]    CHAR (15)     NULL,
    [cpdd_BancoCheque]     CHAR (3)      NOT NULL,
    [cpdd_CopiaCheque]     CHAR (15)     NULL,
    [cpdd_DataPagamento]   SMALLDATETIME NULL,
    [cpdd_BancoPagamento]  CHAR (3)      NOT NULL,
    [cpdd_DataPreDatado]   SMALLDATETIME NULL,
    [cpdd_Grupo]           TINYINT       NOT NULL,
    [cpdd_Destinacao]      TINYINT       NOT NULL,
    [cpdd_Observacao]      VARCHAR (250) NULL,
    [cpdd_NumeroOP]        INT           NULL,
    [cpdd_DataOP]          SMALLDATETIME NULL,
    [cpdd_Valida]          SMALLINT      NULL,
    [cpdd_Lock]            BINARY (8)    NULL
);

