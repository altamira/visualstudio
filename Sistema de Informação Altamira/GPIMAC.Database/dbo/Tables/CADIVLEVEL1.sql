﻿CREATE TABLE [dbo].[CADIVLEVEL1] (
    [CDIVCOD]  CHAR (60)  NOT NULL,
    [CDIV1Seq] SMALLINT   NOT NULL,
    [CDIV1Esp] CHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([CDIVCOD] ASC, [CDIV1Seq] ASC)
);

