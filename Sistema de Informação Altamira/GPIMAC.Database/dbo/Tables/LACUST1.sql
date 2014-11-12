﻿CREATE TABLE [dbo].[LACUST1] (
    [LNCCOD]  CHAR (60) NOT NULL,
    [LNCSeq]  CHAR (2)  NOT NULL,
    [LCCSEQ]  INT       NOT NULL,
    [CSERCOD] CHAR (8)  NOT NULL,
    [CTABCOD] SMALLINT  NULL,
    [LCCPCH]  INT       NULL,
    [LCCPRP]  MONEY     NULL,
    [LCCHGA]  MONEY     NULL,
    PRIMARY KEY CLUSTERED ([LNCCOD] ASC, [LNCSeq] ASC, [LCCSEQ] ASC, [CSERCOD] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ILACUST1B]
    ON [dbo].[LACUST1]([CTABCOD] ASC);


GO
CREATE NONCLUSTERED INDEX [ILACUST1C]
    ON [dbo].[LACUST1]([CSERCOD] ASC);

