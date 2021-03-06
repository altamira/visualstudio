﻿CREATE TABLE [dbo].[LACUST5] (
    [LNCCOD]  CHAR (60)  NOT NULL,
    [LNCSeq]  CHAR (2)   NOT NULL,
    [LCISEQ]  INT        NOT NULL,
    [CDIMCOD] CHAR (3)   NOT NULL,
    [LCIPER]  SMALLMONEY NULL,
    PRIMARY KEY CLUSTERED ([LNCCOD] ASC, [LNCSeq] ASC, [LCISEQ] ASC, [CDIMCOD] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ILACUST5B]
    ON [dbo].[LACUST5]([CDIMCOD] ASC);

