﻿CREATE TABLE [dbo].[CABAM] (
    [CBACOD]    CHAR (3) NOT NULL,
    [CBADATD]   DATETIME NOT NULL,
    [CBASALANT] MONEY    NULL,
    [CBAREGDUL] INT      NULL,
    PRIMARY KEY CLUSTERED ([CBACOD] ASC, [CBADATD] ASC)
);

