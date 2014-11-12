CREATE TABLE [dbo].[CAVEI] (
    [CVei0Cod]     INT        NOT NULL,
    [CVei0Nom]     CHAR (100) NULL,
    [CVei0Mar]     CHAR (100) NULL,
    [CVei0Mod]     CHAR (100) NULL,
    [CVei0AnoMod]  SMALLINT   NULL,
    [CVei0AnoFab]  SMALLINT   NULL,
    [CVei0RENAVAM] CHAR (20)  NULL,
    [CVei0ANTT]    CHAR (20)  NULL,
    [CVei0Pla]     CHAR (10)  NULL,
    [CVei0Pes]     MONEY      NULL,
    [CVei0CgaCap]  MONEY      NULL,
    [CVei0Dat]     DATETIME   NULL,
    [CVei0Atv]     CHAR (1)   NULL,
    PRIMARY KEY CLUSTERED ([CVei0Cod] ASC)
);


GO
CREATE NONCLUSTERED INDEX [UCAVEIA]
    ON [dbo].[CAVEI]([CVei0Nom] ASC);


GO
CREATE NONCLUSTERED INDEX [UCAVEIB]
    ON [dbo].[CAVEI]([CVei0CgaCap] ASC);


GO
CREATE NONCLUSTERED INDEX [UCAVEIC]
    ON [dbo].[CAVEI]([CVei0CgaCap] DESC);


GO
CREATE NONCLUSTERED INDEX [UCAVEID]
    ON [dbo].[CAVEI]([CVei0Pes] ASC);

