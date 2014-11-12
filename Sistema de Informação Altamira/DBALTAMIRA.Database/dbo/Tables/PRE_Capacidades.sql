CREATE TABLE [dbo].[PRE_Capacidades] (
    [prca_DataDoCadastro]   SMALLDATETIME NOT NULL,
    [prca_DataDaAlteração]  SMALLDATETIME NOT NULL,
    [prca_AçoFinaQuente]    FLOAT (53)    NULL,
    [prca_AçoFinaFrio]      FLOAT (53)    NULL,
    [prca_folhaEncargos]    MONEY         NULL,
    [prca_Acessorias]       MONEY         NULL,
    [prca_HorasMensais]     MONEY         NULL,
    [prca_ValordasHoras]    MONEY         NULL,
    [prca_HorasDiárias]     MONEY         NULL,
    [prca_Estimativa]       FLOAT (53)    NULL,
    [prca_TintaemPó]        FLOAT (53)    NULL,
    [prca_Lucro]            FLOAT (53)    NULL,
    [prca_Investimento]     FLOAT (53)    NULL,
    [prca_SaldoFechamentos] MONEY         NULL,
    [prca_Reserva]          FLOAT (53)    NULL
);

