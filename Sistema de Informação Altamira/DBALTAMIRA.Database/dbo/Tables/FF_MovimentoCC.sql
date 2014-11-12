CREATE TABLE [dbo].[FF_MovimentoCC] (
    [ffmv_Sequencia]     INT           IDENTITY (1, 1) NOT NULL,
    [ffmv_Banco]         CHAR (3)      NOT NULL,
    [ffmv_Agencia]       CHAR (6)      NOT NULL,
    [ffmv_Conta]         CHAR (10)     NOT NULL,
    [ffmv_DataMovimento] SMALLDATETIME NOT NULL,
    [ffmv_NumeroCheque]  CHAR (15)     NULL,
    [ffmv_Liquidado]     CHAR (1)      NOT NULL,
    [ffmv_Descricao]     VARCHAR (50)  NOT NULL,
    [ffmv_Valor]         MONEY         NOT NULL,
    [ffmv_Operacao]      CHAR (1)      NOT NULL,
    [ffmv_Investimento]  CHAR (1)      NOT NULL,
    [ffmv_Lock]          BINARY (8)    NULL
);

