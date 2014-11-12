CREATE TABLE [dbo].[CAPROCOTLEVEL1] (
    [CPROCOD]       CHAR (60)       NOT NULL,
    [CProCotCCCGC]  CHAR (18)       NOT NULL,
    [CProCotCont]   CHAR (100)      NULL,
    [CProCotDDD]    CHAR (3)        NULL,
    [CProCotFone]   CHAR (9)        NULL,
    [CProCotICMS]   SMALLMONEY      NULL,
    [CProCotIPI]    SMALLMONEY      NULL,
    [CProCotQtde]   DECIMAL (11, 4) NULL,
    [CProCotVal]    MONEY           NULL,
    [CProCotDtComp] DATETIME        NULL,
    [CProCotNunNF]  DECIMAL (10)    NULL,
    [CProCotCod]    CHAR (30)       NULL,
    PRIMARY KEY CLUSTERED ([CPROCOD] ASC, [CProCotCCCGC] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ICAPROCOTLEVEL13]
    ON [dbo].[CAPROCOTLEVEL1]([CProCotCCCGC] ASC);

