CREATE TABLE [dbo].[CAPCL1] (
    [Pc0Cod]       INT        NOT NULL,
    [Pc1Cod]       SMALLINT   NOT NULL,
    [Pc1Nom]       CHAR (40)  NULL,
    [Pc1TelDdd]    CHAR (3)   NULL,
    [Pc1TelNum]    CHAR (15)  NULL,
    [Pc1TelRam]    CHAR (5)   NULL,
    [Pc1FaxDdd]    CHAR (3)   NULL,
    [Pc1FaxNum]    CHAR (15)  NULL,
    [Pc1FaxRam]    CHAR (5)   NULL,
    [Pc1CelDdd]    CHAR (3)   NULL,
    [Pc1CelNum]    CHAR (15)  NULL,
    [Pc1Dep]       CHAR (35)  NULL,
    [Pc1Cgo]       CHAR (35)  NULL,
    [Pc1Eml]       CHAR (100) NULL,
    [Pc1Pc0CodOld] INT        NULL,
    [Pc1CodOld]    INT        NULL,
    PRIMARY KEY CLUSTERED ([Pc0Cod] ASC, [Pc1Cod] ASC)
);


GO
CREATE NONCLUSTERED INDEX [UCAPCL1A]
    ON [dbo].[CAPCL1]([Pc0Cod] ASC, [Pc1Nom] ASC);


GO
CREATE NONCLUSTERED INDEX [UCAPCL1B]
    ON [dbo].[CAPCL1]([Pc0Cod] ASC, [Pc1Cod] DESC);


GO
GRANT SELECT
    ON OBJECT::[dbo].[CAPCL1] TO [altanet]
    AS [dbo];

