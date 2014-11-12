﻿CREATE TABLE [dbo].[LPVSITETAPA] (
    [LPEMP]          CHAR (2)   NOT NULL,
    [LPPED]          INT        NOT NULL,
    [LPEt2Seq]       SMALLINT   NOT NULL,
    [LPEt2Des]       CHAR (50)  NULL,
    [LPEt2IniDat]    DATETIME   NULL,
    [LPEt2IniUsuCri] CHAR (20)  NULL,
    [LPEt2IniDtHCri] DATETIME   NULL,
    [LPEt2PrFDat]    DATETIME   NULL,
    [LPEt2PrFDtHCri] DATETIME   NULL,
    [LPEt2PrFUsuCri] CHAR (20)  NULL,
    [LpEt2Obs]       CHAR (250) NULL,
    PRIMARY KEY CLUSTERED ([LPEMP] ASC, [LPPED] ASC, [LPEt2Seq] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ULPVSITETAPAA]
    ON [dbo].[LPVSITETAPA]([LPEMP] ASC, [LPPED] ASC, [LPEt2IniDat] DESC);

