CREATE TABLE [dbo].[LNF] (
    [Lnf0Emp]       CHAR (2)       NOT NULL,
    [Lnf0Nfo]       INT            NOT NULL,
    [Lnf0Seq]       SMALLINT       NOT NULL,
    [Lnf0CliCnpj]   CHAR (18)      NOT NULL,
    [Lnf0Dat]       DATETIME       NULL,
    [Lnf0DatEmi]    DATETIME       NULL,
    [Lnf0DatEnt]    DATETIME       NULL,
    [Lnf0CoCod]     CHAR (6)       NULL,
    [Lnf0CpCod]     CHAR (3)       NULL,
    [Lnf0IcmBasMPA] MONEY          NULL,
    [Lnf0FreTot]    MONEY          NULL,
    [Lnf0Obs]       VARCHAR (5000) NULL,
    [Lnf0FreIcmTrb] CHAR (1)       NULL,
    [Lnf0Bai]       CHAR (1)       NULL,
    [Lnf0DupQtdPar] SMALLINT       NULL,
    [Lnf0DupVen01]  DATETIME       NULL,
    [Lnf0DupVen02]  DATETIME       NULL,
    [Lnf0DupVen03]  DATETIME       NULL,
    [Lnf0DupVen04]  DATETIME       NULL,
    [Lnf0DupVen05]  DATETIME       NULL,
    [Lnf0DupVen06]  DATETIME       NULL,
    [Lnf0DupVen07]  DATETIME       NULL,
    [Lnf0DupVen08]  DATETIME       NULL,
    [Lnf0DupVen09]  DATETIME       NULL,
    [Lnf0FreIpiAli] SMALLMONEY     NULL,
    [Lnf0UsoCon]    CHAR (1)       NULL,
    [Lnf0FreIpiTrb] CHAR (1)       NULL,
    [Lnf0DupVal01]  MONEY          NULL,
    [Lnf0DupVal02]  MONEY          NULL,
    [Lnf0DupVal03]  MONEY          NULL,
    [Lnf0DupVal04]  MONEY          NULL,
    [Lnf0DupVal05]  MONEY          NULL,
    [Lnf0DupVal06]  MONEY          NULL,
    [Lnf0DupVal07]  MONEY          NULL,
    [Lnf0DupVal08]  MONEY          NULL,
    [Lnf0DupVal09]  MONEY          NULL,
    [Lnf0DupVen10]  DATETIME       NULL,
    [Lnf0DupVal10]  MONEY          NULL,
    [Lnf0FreIcmAli] SMALLMONEY     NULL,
    [Lnf0FatDes]    MONEY          NULL,
    [Lnf0FatAcr]    MONEY          NULL,
    [Lnf0FatGer]    CHAR (1)       NULL,
    [Lnf0TotDes]    MONEY          NULL,
    [Lnf0TotAcr]    MONEY          NULL,
    [Lnf0IcmTotMPA] MONEY          NULL,
    [Lnf0UF]        CHAR (2)       NULL,
    [Lnf0Fei]       CHAR (20)      NULL,
    [Lnf0Tip]       CHAR (2)       NULL,
    [Lnf0SrVDes]    CHAR (100)     NULL,
    [Lnf0SrVTot]    MONEY          NULL,
    [Lnf0ChaAce]    CHAR (44)      NULL,
    [Lnf0SPlCod]    CHAR (3)       NULL,
    [Lnf0PlaCod]    CHAR (3)       NULL,
    [Lnf0CaPlC0Cod] CHAR (11)      NULL,
    PRIMARY KEY CLUSTERED ([Lnf0Emp] ASC, [Lnf0Nfo] ASC, [Lnf0Seq] ASC, [Lnf0CliCnpj] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ILNFB]
    ON [dbo].[LNF]([Lnf0CpCod] ASC);


GO
CREATE NONCLUSTERED INDEX [ILNFC]
    ON [dbo].[LNF]([Lnf0CoCod] ASC);


GO
CREATE NONCLUSTERED INDEX [ILNFD]
    ON [dbo].[LNF]([Lnf0CliCnpj] ASC);


GO
CREATE NONCLUSTERED INDEX [ULNFA]
    ON [dbo].[LNF]([Lnf0DatEmi] ASC);


GO
CREATE NONCLUSTERED INDEX [ULNFB]
    ON [dbo].[LNF]([Lnf0DatEnt] ASC);


GO
CREATE NONCLUSTERED INDEX [ULNFC]
    ON [dbo].[LNF]([Lnf0Nfo] ASC, [Lnf0DatEmi] ASC);


GO
CREATE NONCLUSTERED INDEX [ULNFD]
    ON [dbo].[LNF]([Lnf0Nfo] ASC, [Lnf0DatEnt] ASC);


GO
CREATE NONCLUSTERED INDEX [ULNFE]
    ON [dbo].[LNF]([Lnf0Emp] ASC, [Lnf0DatEmi] ASC);


GO
CREATE NONCLUSTERED INDEX [ULNFF]
    ON [dbo].[LNF]([Lnf0Emp] ASC, [Lnf0DatEmi] DESC);


GO
CREATE NONCLUSTERED INDEX [ULFNG]
    ON [dbo].[LNF]([Lnf0Emp] ASC, [Lnf0Nfo] ASC, [Lnf0CliCnpj] ASC, [Lnf0Seq] DESC);


GO
CREATE NONCLUSTERED INDEX [ULNFH]
    ON [dbo].[LNF]([Lnf0Emp] ASC, [Lnf0DatEnt] ASC, [Lnf0Nfo] ASC);


GO
CREATE NONCLUSTERED INDEX [ULNFI]
    ON [dbo].[LNF]([Lnf0Emp] ASC, [Lnf0DatEnt] DESC, [Lnf0Nfo] DESC);


GO
CREATE NONCLUSTERED INDEX [ULNFJ]
    ON [dbo].[LNF]([Lnf0Emp] ASC, [Lnf0DatEnt] DESC, [Lnf0Nfo] ASC);


GO
CREATE NONCLUSTERED INDEX [ILNFE]
    ON [dbo].[LNF]([Lnf0SPlCod] ASC);


GO
CREATE NONCLUSTERED INDEX [ILNFF]
    ON [dbo].[LNF]([Lnf0PlaCod] ASC);


GO
CREATE NONCLUSTERED INDEX [ILNFG]
    ON [dbo].[LNF]([Lnf0CaPlC0Cod] ASC);

