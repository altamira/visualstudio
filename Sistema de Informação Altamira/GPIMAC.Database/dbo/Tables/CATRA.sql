CREATE TABLE [dbo].[CATRA] (
    [CTCOD]        CHAR (5)  NOT NULL,
    [CTNOM]        CHAR (50) NULL,
    [CTEND]        CHAR (50) NULL,
    [CTBAI]        CHAR (30) NULL,
    [CTCID]        CHAR (50) NULL,
    [CTEST]        CHAR (2)  NULL,
    [CTPLA]        CHAR (8)  NULL,
    [CTFON]        CHAR (9)  NULL,
    [CTINS]        CHAR (20) NULL,
    [CTCGC]        CHAR (18) NULL,
    [CTTIP]        CHAR (1)  NULL,
    [CTDDD]        CHAR (5)  NULL,
    [CTFOD]        CHAR (5)  NULL,
    [CTFO1]        CHAR (9)  NULL,
    [CTCODANTT]    CHAR (20) NULL,
    [CTPLAUF]      CHAR (2)  NULL,
    [CTCIDIBGECOD] INT       NULL,
    [CTCON]        CHAR (30) NULL,
    [CTCEP]        CHAR (9)  NULL,
    [CTAtv]        CHAR (1)  NULL,
    [CTFRE]        CHAR (1)  NULL,
    [CTLogTip0Cod] CHAR (3)  NULL,
    [CTEndNum]     CHAR (10) NULL,
    [CTEndCpl]     CHAR (30) NULL,
    [CTFONRAM]     CHAR (5)  NULL,
    [CTFO1RAM]     CHAR (5)  NULL,
    PRIMARY KEY CLUSTERED ([CTCOD] ASC)
);


GO
CREATE NONCLUSTERED INDEX [UCATRAA]
    ON [dbo].[CATRA]([CTNOM] ASC);


GO
CREATE NONCLUSTERED INDEX [UCATRAB]
    ON [dbo].[CATRA]([CTCGC] ASC);


GO
CREATE NONCLUSTERED INDEX [ICATRAB]
    ON [dbo].[CATRA]([CTCIDIBGECOD] ASC);


GO
CREATE NONCLUSTERED INDEX [ICATRAC]
    ON [dbo].[CATRA]([CTEST] ASC);


GO
CREATE NONCLUSTERED INDEX [ICATRA]
    ON [dbo].[CATRA]([CTLogTip0Cod] ASC);

