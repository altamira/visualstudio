﻿CREATE TABLE [dbo].[CCOEMP] (
    [CEMPCOD]   CHAR (2)      NOT NULL,
    [CBACOD]    CHAR (3)      NOT NULL,
    [CagCod]    SMALLINT      NOT NULL,
    [CcoCod]    CHAR (11)     NOT NULL,
    [EmpLogBco] VARCHAR (400) NULL,
    [DesCod]    SMALLINT      NULL,
    PRIMARY KEY CLUSTERED ([CEMPCOD] ASC, [CBACOD] ASC, [CagCod] ASC, [CcoCod] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ICCOEMP1]
    ON [dbo].[CCOEMP]([CcoCod] ASC, [CagCod] ASC, [CBACOD] ASC);


GO
CREATE NONCLUSTERED INDEX [ICCOEMP3]
    ON [dbo].[CCOEMP]([DesCod] ASC);

