﻿CREATE TABLE [dbo].[SGMOD] (
    [SgMod0Cod] CHAR (3)  NOT NULL,
    [SgMod0Nom] CHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([SgMod0Cod] ASC)
);


GO
CREATE NONCLUSTERED INDEX [USGMODB]
    ON [dbo].[SGMOD]([SgMod0Nom] ASC);

