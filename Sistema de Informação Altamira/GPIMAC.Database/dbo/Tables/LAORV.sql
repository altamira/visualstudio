CREATE TABLE [dbo].[LAORV] (
    [Lo0Emp]         CHAR (2)       NOT NULL,
    [Lo0PED]         INT            NOT NULL,
    [Lo0Dat]         DATETIME       NULL,
    [Lo0DatVal]      CHAR (10)      NULL,
    [Lo0Fei]         CHAR (20)      NULL,
    [Pc0Cod]         INT            NULL,
    [Lo0CvCod]       CHAR (3)       NULL,
    [Pc1Cod]         SMALLINT       NULL,
    [Lo0Obs]         VARCHAR (5000) NULL,
    [Lo0CpCod]       CHAR (3)       NULL,
    [Lo0Lo1]         SMALLINT       NULL,
    [Lo0Fu0]         INT            NULL,
    [Lo0Ref]         CHAR (50)      NULL,
    [Lo0ImpDsc]      CHAR (50)      NULL,
    [Lo0TipVend]     CHAR (50)      NULL,
    [Lo0NomConcorr]  VARCHAR (500)  NULL,
    [Lo0TipMaterial] CHAR (100)     NULL,
    [Lo0DatProxCont] DATETIME       NULL,
    [Lo0ProbFec]     SMALLMONEY     NULL,
    PRIMARY KEY CLUSTERED ([Lo0Emp] ASC, [Lo0PED] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ILAORVB]
    ON [dbo].[LAORV]([Lo0CpCod] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAORVC]
    ON [dbo].[LAORV]([Lo0CvCod] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAORVD]
    ON [dbo].[LAORV]([Pc0Cod] ASC, [Pc1Cod] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAORVA]
    ON [dbo].[LAORV]([Lo0Dat] DESC, [Lo0PED] DESC);


GO
CREATE NONCLUSTERED INDEX [ULAORVB]
    ON [dbo].[LAORV]([Lo0PED] DESC);

