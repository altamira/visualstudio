CREATE TABLE [dbo].[CP_SinalPedido] (
    [cpsp_Sequencia]      INT           NOT NULL,
    [cpsp_Pedido]         INT           NOT NULL,
    [cpsp_DataVencimento] SMALLDATETIME NULL,
    [cpsp_Valor]          MONEY         NOT NULL,
    [cpsp_NumeroCheque]   CHAR (15)     NULL,
    [cpsp_BancoCheque]    CHAR (3)      NULL,
    [cpsp_CopiaCheque]    INT           NULL,
    [cpsp_DataPagamento]  SMALLDATETIME NULL,
    [cpsp_BancoPagamento] CHAR (3)      NULL,
    [cpsp_DataPreDatado]  SMALLDATETIME NULL,
    [cpsp_NumeroOP]       INT           NULL,
    [cpsp_DataOP]         SMALLDATETIME NULL,
    [cpsp_Observacao]     VARCHAR (50)  NULL,
    [cpsp_Exclusao]       CHAR (1)      NULL,
    [cpsp_Valida]         SMALLINT      NULL,
    [cpsp_Lock]           BINARY (8)    NULL
);

