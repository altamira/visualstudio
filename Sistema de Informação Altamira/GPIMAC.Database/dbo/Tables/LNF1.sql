CREATE TABLE [dbo].[LNF1] (
    [Lnf0Emp]        CHAR (2)        NOT NULL,
    [Lnf0Nfo]        INT             NOT NULL,
    [Lnf0Seq]        SMALLINT        NOT NULL,
    [Lnf0CliCnpj]    CHAR (18)       NOT NULL,
    [Lnf1Seq]        SMALLINT        NOT NULL,
    [Lnf1Cod]        CHAR (60)       NULL,
    [Lnf1Tip]        CHAR (2)        NULL,
    [Lnf1Pre]        DECIMAL (13, 4) NULL,
    [Lnf1Qua]        DECIMAL (11, 4) NULL,
    [Lnf1IpiAli]     SMALLMONEY      NULL,
    [Lnf1IcmAli]     SMALLMONEY      NULL,
    [Lnf1ClfPer]     CHAR (10)       NULL,
    [Lnf1PedCodOri]  INT             NULL,
    [Lnf1PedIteOri]  SMALLINT        NULL,
    [Lnf1UsoCon]     CHAR (1)        NULL,
    [LNF1MovEst]     INT             NULL,
    [Lnf1CST]        CHAR (4)        NULL,
    [Lnf1ClfCod]     CHAR (5)        NULL,
    [Lnf1IpiAju]     SMALLMONEY      NULL,
    [Lnf1IcmBasRed]  SMALLMONEY      NULL,
    [Lnf1IcmAju]     SMALLMONEY      NULL,
    [Lnf1IcSTrb]     CHAR (1)        NULL,
    [Lnf1IcSMrC]     SMALLMONEY      NULL,
    [Lnf1IcSAli]     SMALLMONEY      NULL,
    [Lnf1IcSAju]     SMALLMONEY      NULL,
    [LNf1CoCod]      CHAR (6)        NULL,
    [Lnf1TotSom]     CHAR (1)        NULL,
    [Lnf1ProAju]     SMALLMONEY      NULL,
    [Lnf1UniNF]      CHAR (2)        NULL,
    [Lnf1QuaEst]     DECIMAL (11, 4) NULL,
    [Lnf1RBnEnv]     CHAR (1)        NULL,
    [Lnf1TDNFOri]    CHAR (2)        NULL,
    [Lnf1TDNFNumOri] INT             NULL,
    [Lnf1TDNFIteOri] SMALLINT        NULL,
    [Lnf1Est]        CHAR (1)        NULL,
    [Lnf1PorCom]     SMALLMONEY      NULL,
    PRIMARY KEY CLUSTERED ([Lnf0Emp] ASC, [Lnf0Nfo] ASC, [Lnf0Seq] ASC, [Lnf0CliCnpj] ASC, [Lnf1Seq] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ULNF1B]
    ON [dbo].[LNF1]([Lnf1Cod] ASC);


GO
CREATE NONCLUSTERED INDEX [ULNF1A]
    ON [dbo].[LNF1]([LNF1MovEst] ASC, [Lnf1Cod] ASC, [Lnf1Tip] ASC);


GO
CREATE NONCLUSTERED INDEX [ILNF1C]
    ON [dbo].[LNF1]([Lnf1ClfCod] ASC);


GO
CREATE NONCLUSTERED INDEX [ILNF1]
    ON [dbo].[LNF1]([LNf1CoCod] ASC);


GO
CREATE NONCLUSTERED INDEX [ULNF1C]
    ON [dbo].[LNF1]([Lnf0Emp] ASC, [Lnf1PedCodOri] ASC, [Lnf1PedIteOri] ASC);


GO
CREATE NONCLUSTERED INDEX [ULNF1D]
    ON [dbo].[LNF1]([Lnf0Emp] ASC, [Lnf0Nfo] ASC, [Lnf0Seq] ASC, [Lnf0CliCnpj] ASC, [Lnf1Seq] DESC);

