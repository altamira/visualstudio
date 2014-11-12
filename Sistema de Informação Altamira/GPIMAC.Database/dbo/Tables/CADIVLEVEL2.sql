CREATE TABLE [dbo].[CADIVLEVEL2] (
    [CDIVCOD]       CHAR (60)       NOT NULL,
    [CDivCotCCCGC]  CHAR (18)       NOT NULL,
    [CDivCotCont]   CHAR (20)       NULL,
    [CDivCotDDD]    CHAR (3)        NULL,
    [CDivCotFone]   CHAR (9)        NULL,
    [CDivCotICMS]   SMALLMONEY      NULL,
    [CDivCotIPI]    SMALLMONEY      NULL,
    [CDivCotQtde]   DECIMAL (11, 4) NULL,
    [CDivCotPre]    MONEY           NULL,
    [CDivCotDtComp] DATETIME        NULL,
    [CDivCotNunNF]  DECIMAL (10)    NULL,
    PRIMARY KEY CLUSTERED ([CDIVCOD] ASC, [CDivCotCCCGC] ASC)
);


GO
CREATE NONCLUSTERED INDEX [UCADIV2A]
    ON [dbo].[CADIVLEVEL2]([CDivCotDtComp] ASC);


GO
CREATE NONCLUSTERED INDEX [UCADIV2B]
    ON [dbo].[CADIVLEVEL2]([CDivCotDtComp] DESC);


GO
CREATE NONCLUSTERED INDEX [ICADIVLEVEL2]
    ON [dbo].[CADIVLEVEL2]([CDivCotCCCGC] ASC);

