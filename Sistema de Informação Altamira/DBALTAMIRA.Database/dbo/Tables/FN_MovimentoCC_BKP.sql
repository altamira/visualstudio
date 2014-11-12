CREATE TABLE [dbo].[FN_MovimentoCC_BKP] (
    [fnmv_Sequencia]     INT           NOT NULL,
    [fnmv_Banco]         CHAR (3)      NOT NULL,
    [fnmv_Agencia]       CHAR (6)      NOT NULL,
    [fnmv_Conta]         CHAR (10)     NOT NULL,
    [fnmv_DataMovimento] SMALLDATETIME NOT NULL,
    [fnmv_NumeroCheque]  CHAR (15)     NULL,
    [fnmv_Liquidado]     CHAR (1)      NOT NULL,
    [fnmv_Descricao]     VARCHAR (50)  NOT NULL,
    [fnmv_Valor]         MONEY         NOT NULL,
    [fnmv_Operacao]      CHAR (1)      NOT NULL,
    [fnmv_Investimento]  CHAR (1)      NOT NULL,
    [fnmv_Lock]          BINARY (8)    NULL
);

