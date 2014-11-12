CREATE TABLE [dbo].[TSEEX1] (
    [TCTSERID] DECIMAL (14)    NOT NULL,
    [TCtSerCo] CHAR (7)        NOT NULL,
    [TCtSerNo] CHAR (30)       NULL,
    [TCtSerUn] CHAR (2)        NULL,
    [TCtSerQt] DECIMAL (11, 4) NULL,
    PRIMARY KEY CLUSTERED ([TCTSERID] ASC, [TCtSerCo] ASC)
);

