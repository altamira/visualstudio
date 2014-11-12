CREATE TABLE [dbo].[TSEIN1] (
    [TCpsId]     DECIMAL (14) NOT NULL,
    [TCpsSeq]    SMALLINT     NOT NULL,
    [TCSerCod]   CHAR (7)     NOT NULL,
    [TCSerNom]   CHAR (30)    NULL,
    [TCMaqCod]   CHAR (5)     NULL,
    [TCpsQtdHor] INT          NULL,
    PRIMARY KEY CLUSTERED ([TCpsId] ASC, [TCpsSeq] ASC, [TCSerCod] ASC)
);

