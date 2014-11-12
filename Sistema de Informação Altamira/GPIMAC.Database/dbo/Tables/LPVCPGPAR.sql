CREATE TABLE [dbo].[LPVCPGPAR] (
    [LPEMP]           CHAR (2)        NOT NULL,
    [LPPED]           INT             NOT NULL,
    [LpCpg1Par]       SMALLINT        NOT NULL,
    [LpCPg1Tip]       CHAR (3)        NULL,
    [LpCPg1Dias]      SMALLINT        NULL,
    [LpCPg1DtV]       DATETIME        NULL,
    [LpCPg1Imp]       CHAR (1)        NULL,
    [LpCPg1ImpVal]    MONEY           NULL,
    [LpCPg1ParVal]    MONEY           NULL,
    [LpCPg1ProVal]    MONEY           NULL,
    [LpCPg1ParIdxRed] DECIMAL (11, 8) NULL,
    [LpCPg1ProIdxRed] DECIMAL (11, 8) NULL,
    [LpCPg1ImpIdxRed] DECIMAL (11, 8) NULL,
    PRIMARY KEY CLUSTERED ([LPEMP] ASC, [LPPED] ASC, [LpCpg1Par] ASC)
);

