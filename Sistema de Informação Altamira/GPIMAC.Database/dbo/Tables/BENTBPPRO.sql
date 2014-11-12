﻿CREATE TABLE [dbo].[BENTBPPRO] (
    [BTb0ForCnpj] CHAR (18)       NOT NULL,
    [BTb0Cod]     CHAR (7)        NOT NULL,
    [BTb1ProCod]  CHAR (60)       NOT NULL,
    [BTb1SExCod]  CHAR (7)        NOT NULL,
    [BTb1PreUni]  DECIMAL (10, 4) NULL,
    [BTb1Atv]     CHAR (1)        NULL,
    PRIMARY KEY CLUSTERED ([BTb0ForCnpj] ASC, [BTb0Cod] ASC, [BTb1ProCod] ASC, [BTb1SExCod] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IBENTBPPROB]
    ON [dbo].[BENTBPPRO]([BTb1SExCod] ASC);


GO
CREATE NONCLUSTERED INDEX [IBENTBPPROC]
    ON [dbo].[BENTBPPRO]([BTb1ProCod] ASC);


GO
CREATE NONCLUSTERED INDEX [UBENTBPPROA]
    ON [dbo].[BENTBPPRO]([BTb0ForCnpj] ASC, [BTb0Cod] ASC, [BTb1SExCod] ASC);

