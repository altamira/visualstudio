﻿CREATE TABLE [dbo].[CASTA] (
    [CSta0Cod] INT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [CStA0Nom] CHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([CSta0Cod] ASC)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[CASTA] TO [altanet]
    AS [dbo];

