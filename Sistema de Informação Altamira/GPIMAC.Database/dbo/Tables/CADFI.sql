﻿CREATE TABLE [dbo].[CADFI] (
    [CaDFI0Cod]    CHAR (2)  NOT NULL,
    [CaDFI0Nom]    CHAR (70) NULL,
    [CaDFI0Mod]    CHAR (5)  NULL,
    [CaDFI0CodNom] CHAR (75) NULL,
    PRIMARY KEY CLUSTERED ([CaDFI0Cod] ASC)
);


GO
CREATE NONCLUSTERED INDEX [UCADFIB]
    ON [dbo].[CADFI]([CaDFI0Nom] ASC);


GO
CREATE NONCLUSTERED INDEX [UCADFIC]
    ON [dbo].[CADFI]([CaDFI0Mod] ASC);

