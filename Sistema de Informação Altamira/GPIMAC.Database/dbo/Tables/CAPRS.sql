﻿CREATE TABLE [dbo].[CAPRS] (
    [CPrS0Cod]    INT        NOT NULL,
    [CPrS0Nom]    CHAR (50)  NULL,
    [CPrS0ISSAli] SMALLMONEY NULL,
    PRIMARY KEY CLUSTERED ([CPrS0Cod] ASC)
);


GO
CREATE NONCLUSTERED INDEX [UCAPRSB]
    ON [dbo].[CAPRS]([CPrS0Nom] ASC);

