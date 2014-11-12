CREATE TABLE [dbo].[LPC1] (
    [Lpc0Emp]       CHAR (2)        NOT NULL,
    [Lpc0Ped]       INT             NOT NULL,
    [Lpc1Seq]       SMALLINT        NOT NULL,
    [Lpc1Cod]       CHAR (60)       NULL,
    [Lpc1Tip]       CHAR (2)        NULL,
    [Lpc1Pre]       DECIMAL (13, 4) NULL,
    [Lpc1Qua]       DECIMAL (11, 4) NULL,
    [Lpc1Ent]       DATETIME        NULL,
    [Lpc1Ipi]       SMALLMONEY      NULL,
    [Lpc1Icm]       SMALLMONEY      NULL,
    [Lrc0Emp]       CHAR (2)        NULL,
    [Lrc0Cod]       INT             NULL,
    [Lrc1Seq]       SMALLINT        NULL,
    [Lpc1QuaBai]    DECIMAL (11, 4) NULL,
    [Lpc1SalRed]    DECIMAL (11, 4) NULL,
    [Lpc1DesDet]    VARCHAR (2000)  NULL,
    [Lpc1DesVal]    DECIMAL (13, 4) NULL,
    [Lpc1Uni2]      CHAR (2)        NULL,
    [Lpc1SalRecRed] DECIMAL (11, 4) NULL,
    PRIMARY KEY CLUSTERED ([Lpc0Emp] ASC, [Lpc0Ped] ASC, [Lpc1Seq] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ULPC1A]
    ON [dbo].[LPC1]([Lpc1Cod] ASC);


GO
CREATE NONCLUSTERED INDEX [ILPC1B]
    ON [dbo].[LPC1]([Lrc0Emp] ASC, [Lrc0Cod] ASC, [Lrc1Seq] ASC);


GO
CREATE NONCLUSTERED INDEX [ULPC1B]
    ON [dbo].[LPC1]([Lpc0Emp] ASC, [Lpc1Ent] ASC);


GO
CREATE NONCLUSTERED INDEX [ULPC1C]
    ON [dbo].[LPC1]([Lpc0Emp] ASC, [Lpc1Ent] DESC);


GO
CREATE NONCLUSTERED INDEX [ULPC1D]
    ON [dbo].[LPC1]([Lpc1Ent] ASC);


GO
CREATE NONCLUSTERED INDEX [ULPC1E]
    ON [dbo].[LPC1]([Lpc0Emp] ASC, [Lpc0Ped] ASC, [Lpc1Seq] DESC);


GO
CREATE NONCLUSTERED INDEX [ULPC1F]
    ON [dbo].[LPC1]([Lpc0Ped] ASC, [Lpc1Seq] ASC);


GO
CREATE NONCLUSTERED INDEX [ULPC1G]
    ON [dbo].[LPC1]([Lpc0Emp] ASC, [Lpc1Cod] ASC);

