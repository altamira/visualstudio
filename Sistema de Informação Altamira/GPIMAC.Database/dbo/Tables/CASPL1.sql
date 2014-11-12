﻿CREATE TABLE [dbo].[CASPL1] (
    [C2PLA]  CHAR (3)  NOT NULL,
    [C2SEQ]  INT       NOT NULL,
    [C2DATA] DATETIME  NULL,
    [C2DOC]  INT       NULL,
    [C2DES]  CHAR (30) NULL,
    [C2VALO] MONEY     NULL,
    [C2CHE]  CHAR (12) NULL,
    PRIMARY KEY CLUSTERED ([C2PLA] ASC, [C2SEQ] ASC)
);

