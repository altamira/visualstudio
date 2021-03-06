﻿CREATE TABLE [dbo].[CAPROATPRE] (
    [ATNUM]  INT        NOT NULL,
    [ATDAT]  DATETIME   NULL,
    [ATDES]  CHAR (50)  NULL,
    [ATPER]  SMALLMONEY NULL,
    [ATPCUS] SMALLMONEY NULL,
    [CGrco1] CHAR (5)   NULL,
    PRIMARY KEY CLUSTERED ([ATNUM] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ICAPROATPRE1]
    ON [dbo].[CAPROATPRE]([CGrco1] ASC);

