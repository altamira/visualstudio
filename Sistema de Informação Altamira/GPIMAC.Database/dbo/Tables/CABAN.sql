﻿CREATE TABLE [dbo].[CABAN] (
    [CBACOD]   CHAR (3)        NOT NULL,
    [CBANOM]   CHAR (30)       NULL,
    [CBASAL]   MONEY           NULL,
    [CBASAL1]  MONEY           NULL,
    [CBASAL2]  MONEY           NULL,
    [CBREGULT] INT             NULL,
    [CBASel]   SMALLINT        NULL,
    [CBADG]    SMALLINT        NULL,
    [CBLOGBAN] VARBINARY (MAX) NULL,
    PRIMARY KEY CLUSTERED ([CBACOD] ASC)
);


GO
CREATE NONCLUSTERED INDEX [UCABAN]
    ON [dbo].[CABAN]([CBANOM] ASC);

