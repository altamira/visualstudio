CREATE TABLE [dbo].[LPC] (
    [Lpc0Emp]             CHAR (2)       NOT NULL,
    [Lpc0Ped]             INT            NOT NULL,
    [Lpc0Dat]             DATETIME       NULL,
    [Lpc0CliCnpj]         CHAR (18)      NULL,
    [Lpc0CpCod]           CHAR (3)       NULL,
    [Lpc0ComNom]          CHAR (30)      NULL,
    [Lpc0Obs]             VARCHAR (5000) NULL,
    [Lpc0Bai]             CHAR (1)       NULL,
    [Lpc0Lpc1]            SMALLINT       NULL,
    [Lpc0FreVal]          MONEY          NULL,
    [Lpc0Sol]             CHAR (50)      NULL,
    [Lpc0Fre]             CHAR (1)       NULL,
    [Lpc0Des]             CHAR (80)      NULL,
    [Lpc0CliConCod]       SMALLINT       NULL,
    [Lpc0PedSalRed]       MONEY          NULL,
    [Lpc0TotVsalRed]      MONEY          NULL,
    [Lpc0TotSalRed]       MONEY          NULL,
    [Lpc0TotRed]          MONEY          NULL,
    [Lpc0IpiSalRed]       MONEY          NULL,
    [Lpc0IpiTotRed]       MONEY          NULL,
    [Lpc0SerTotRed]       MONEY          NULL,
    [Lpc0ProSalRed]       MONEY          NULL,
    [Lpc0ProTotRed]       MONEY          NULL,
    [Lpc0ProTotSemDesRed] MONEY          NULL,
    [Lpc0DesTotRed]       MONEY          NULL,
    PRIMARY KEY CLUSTERED ([Lpc0Emp] ASC, [Lpc0Ped] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ILPCB]
    ON [dbo].[LPC]([Lpc0CpCod] ASC);


GO
CREATE NONCLUSTERED INDEX [ILPC]
    ON [dbo].[LPC]([Lpc0CliCnpj] ASC, [Lpc0CliConCod] ASC);


GO
CREATE NONCLUSTERED INDEX [ULPCA]
    ON [dbo].[LPC]([Lpc0Dat] ASC);


GO
CREATE NONCLUSTERED INDEX [ULPCB]
    ON [dbo].[LPC]([Lpc0Ped] ASC, [Lpc0Dat] ASC);


GO
CREATE NONCLUSTERED INDEX [ULPCC]
    ON [dbo].[LPC]([Lpc0Ped] DESC, [Lpc0Dat] ASC);


GO
CREATE NONCLUSTERED INDEX [ULPCD]
    ON [dbo].[LPC]([Lpc0Emp] ASC, [Lpc0CliCnpj] ASC, [Lpc0Ped] ASC);

