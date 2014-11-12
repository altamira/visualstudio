﻿CREATE TABLE [dbo].[CAMDA] (
    [CMdA0Cod] INT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [CMdA0Nom] CHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([CMdA0Cod] ASC)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[CAMDA] TO [altanet]
    AS [dbo];

