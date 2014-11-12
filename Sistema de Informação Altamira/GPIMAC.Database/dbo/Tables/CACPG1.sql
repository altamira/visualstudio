CREATE TABLE [dbo].[CACPG1] (
    [CPCOD]       CHAR (3)        NOT NULL,
    [CCPg1Seq]    SMALLINT        NOT NULL,
    [CCPg1Dia]    SMALLINT        NULL,
    [CCPg1Por]    DECIMAL (11, 8) NULL,
    [CCPg1DiaTip] CHAR (3)        NULL,
    [CCPg1Cod]    VARCHAR (500)   NULL,
    PRIMARY KEY CLUSTERED ([CPCOD] ASC, [CCPg1Seq] ASC)
);

