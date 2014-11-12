CREATE TABLE [dbo].[NFECCE] (
    [NFe0Emp]            CHAR (2)       NOT NULL,
    [NFe0FatNum]         INT            NOT NULL,
    [NFe0FatTip]         CHAR (1)       NOT NULL,
    [NFe0FatCnpjCpfEmi]  CHAR (14)      NOT NULL,
    [Nfe0CCe_nSeqEvento] SMALLINT       NOT NULL,
    [Nfe0CCe_dhEvento]   DATETIME       NULL,
    [Nfe0CCe_xCorrecao]  VARCHAR (1000) NULL,
    [Nfe0CCe_sDesRec]    CHAR (200)     NULL,
    [NFe0CCe_sRecibo]    CHAR (30)      NULL,
    [Nfe0CCe_nRecibo]    CHAR (100)     NULL,
    PRIMARY KEY CLUSTERED ([NFe0Emp] ASC, [NFe0FatNum] ASC, [NFe0FatTip] ASC, [NFe0FatCnpjCpfEmi] ASC, [Nfe0CCe_nSeqEvento] ASC)
);

