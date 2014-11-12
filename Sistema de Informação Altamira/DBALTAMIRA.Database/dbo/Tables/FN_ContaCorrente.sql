CREATE TABLE [dbo].[FN_ContaCorrente] (
    [fncc_Banco]              CHAR (3)      NOT NULL,
    [fncc_Agencia]            CHAR (10)     NOT NULL,
    [fncc_Conta]              CHAR (10)     NOT NULL,
    [fncc_Gerente]            VARCHAR (30)  NULL,
    [fncc_Telefone]           CHAR (10)     NULL,
    [fncc_Previsao]           CHAR (1)      NOT NULL,
    [fncc_SaldoInicial]       MONEY         NOT NULL,
    [fncc_DataSaldoInicial]   SMALLDATETIME NOT NULL,
    [fncc_DataSaldoAtual]     SMALLDATETIME NOT NULL,
    [fncc_DataSaldoConferido] SMALLDATETIME NOT NULL,
    [fncc_DataRelatorio]      SMALLDATETIME NULL,
    [fncc_Lock]               BINARY (8)    NULL,
    CONSTRAINT [PK_FN_ContaCorrente] PRIMARY KEY NONCLUSTERED ([fncc_Banco] ASC, [fncc_Agencia] ASC, [fncc_Conta] ASC) WITH (FILLFACTOR = 90)
);

