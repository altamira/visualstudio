CREATE TABLE [dbo].[ATDPRO] (
    [Atd0Cod]    INT        NOT NULL,
    [Atd1Seq]    SMALLINT   NOT NULL,
    [Atd1ProCod] CHAR (60)  NOT NULL,
    [Atd1ProNom] CHAR (120) NOT NULL,
    [Atd1Sel]    CHAR (1)   NULL,
    PRIMARY KEY CLUSTERED ([Atd0Cod] ASC, [Atd1Seq] ASC)
);

