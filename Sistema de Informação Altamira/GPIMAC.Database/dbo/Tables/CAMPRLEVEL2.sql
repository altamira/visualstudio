﻿CREATE TABLE [dbo].[CAMPRLEVEL2] (
    [CMPCOD]  CHAR (60)  NOT NULL,
    [CMP2Seq] SMALLINT   NOT NULL,
    [CMPDE1]  CHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([CMPCOD] ASC, [CMP2Seq] ASC)
);

