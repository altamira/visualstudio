CREATE TABLE [dbo].[LPV1] (
    [LPEMP]          CHAR (2)        NOT NULL,
    [LPPED]          INT             NOT NULL,
    [LPSEQ]          SMALLINT        NOT NULL,
    [CPROCOD]        CHAR (60)       NULL,
    [LP1CLI]         CHAR (15)       NULL,
    [LPDEC]          SMALLMONEY      NULL,
    [LPIPI]          SMALLMONEY      NULL,
    [LPNCL]          CHAR (20)       NULL,
    [LPQUA]          DECIMAL (11, 4) NULL,
    [LPPRE]          DECIMAL (13, 4) NULL,
    [LPBTO]          MONEY           NULL,
    [LPSAI]          DATETIME        NULL,
    [LPLo1Seq]       SMALLINT        NULL,
    [LP1PrPTip]      CHAR (1)        NULL,
    [LPGER]          CHAR (1)        NULL,
    [LPGERDES]       CHAR (3)        NULL,
    [LPGUIA]         INT             NULL,
    [LPBAIEXP]       DECIMAL (11, 4) NULL,
    [LPSalRed]       DECIMAL (11, 4) NULL,
    [Lp1DesDet]      VARCHAR (2000)  NULL,
    [CCorCod]        CHAR (10)       NULL,
    [LPWBCCADORCITM] SMALLINT        NULL,
    [Lp1OPAprObs]    CHAR (150)      NULL,
    [Lp1OPAprUsuDtH] DATETIME        NULL,
    [Lp1OPAprUsuDat] DATETIME        NULL,
    [Lp1OPAprUsu]    CHAR (20)       NULL,
    [LP1OPApr]       CHAR (1)        NULL,
    [LPGerNumRed]    INT             NULL,
    [LPWBCCADSGRCOD] INT             NULL,
    [LPWBCCADGRPCOD] INT             NULL,
    [Lp1DesTec]      VARCHAR (2000)  NULL,
    [Lp1DatCnf]      DATETIME        NULL,
    PRIMARY KEY CLUSTERED ([LPEMP] ASC, [LPPED] ASC, [LPSEQ] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ULPV1A]
    ON [dbo].[LPV1]([LPEMP] ASC, [LPPED] ASC, [CPROCOD] ASC);


GO
CREATE NONCLUSTERED INDEX [ULPV1B]
    ON [dbo].[LPV1]([CPROCOD] ASC, [LPSAI] ASC);


GO
CREATE NONCLUSTERED INDEX [ULPV1C]
    ON [dbo].[LPV1]([LPSAI] ASC);


GO
CREATE NONCLUSTERED INDEX [ULPV1D]
    ON [dbo].[LPV1]([LPPED] ASC);


GO
CREATE NONCLUSTERED INDEX [ULPV1E]
    ON [dbo].[LPV1]([LPGUIA] ASC);


GO
CREATE NONCLUSTERED INDEX [ULPV1F]
    ON [dbo].[LPV1]([LPEMP] ASC, [CPROCOD] ASC);


GO
CREATE NONCLUSTERED INDEX [ILPV11]
    ON [dbo].[LPV1]([CCorCod] ASC);


GO
CREATE NONCLUSTERED INDEX [ULPVG]
    ON [dbo].[LPV1]([LPEMP] ASC, [LPPED] ASC, [LPSAI] ASC);


GO
GRANT SELECT
    ON OBJECT::[dbo].[LPV1] TO [altanet]
    AS [dbo];

