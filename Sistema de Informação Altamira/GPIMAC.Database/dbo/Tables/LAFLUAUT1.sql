﻿CREATE TABLE [dbo].[LAFLUAUT1] (
    [CEMPCOD] CHAR (2) NOT NULL,
    [FluNum]  INT      NOT NULL,
    [Flu1Seq] SMALLINT NOT NULL,
    [Flu1Dta] DATETIME NULL,
    [Flu1Val] MONEY    NULL,
    PRIMARY KEY CLUSTERED ([CEMPCOD] ASC, [FluNum] ASC, [Flu1Seq] ASC)
);

