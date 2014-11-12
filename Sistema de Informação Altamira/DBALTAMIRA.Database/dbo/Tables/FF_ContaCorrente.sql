CREATE TABLE [dbo].[FF_ContaCorrente] (
    [ffcc_Banco]              CHAR (3)      NOT NULL,
    [ffcc_Agencia]            CHAR (6)      NOT NULL,
    [ffcc_Conta]              CHAR (10)     NOT NULL,
    [ffcc_Gerente]            VARCHAR (30)  NULL,
    [ffcc_Telefone]           CHAR (10)     NULL,
    [ffcc_Previsao]           CHAR (1)      NOT NULL,
    [ffcc_SaldoInicial]       MONEY         NOT NULL,
    [ffcc_DataSaldoInicial]   SMALLDATETIME NOT NULL,
    [ffcc_DataSaldoAtual]     SMALLDATETIME NOT NULL,
    [ffcc_DataSaldoConferido] SMALLDATETIME NOT NULL,
    [ffcc_DataRelatorio]      SMALLDATETIME NULL,
    [ffcc_Lock]               BINARY (8)    NULL
);

