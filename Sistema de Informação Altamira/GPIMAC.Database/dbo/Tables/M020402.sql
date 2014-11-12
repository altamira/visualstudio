﻿CREATE TABLE [dbo].[M020402] (
    [LCDCOD]    INT       NOT NULL,
    [LCDEMP]    CHAR (2)  NOT NULL,
    [CSETCOD]   CHAR (3)  NULL,
    [LCDRET]    CHAR (10) NULL,
    [TRACOD]    CHAR (6)  NULL,
    [LCDENT]    DATETIME  NULL,
    [LCDSAI]    DATETIME  NULL,
    [LCDULTSEQ] SMALLINT  NULL,
    [LCDSTA]    CHAR (1)  NULL,
    PRIMARY KEY CLUSTERED ([LCDCOD] ASC, [LCDEMP] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IM020402B]
    ON [dbo].[M020402]([TRACOD] ASC);


GO
CREATE NONCLUSTERED INDEX [IM020402C]
    ON [dbo].[M020402]([CSETCOD] ASC);


GO
CREATE NONCLUSTERED INDEX [UM020402A]
    ON [dbo].[M020402]([LCDENT] ASC);

