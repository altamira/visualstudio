CREATE TABLE [dbo].[BENTBP] (
    [BTb0ForCnpj] CHAR (18)  NOT NULL,
    [BTb0Cod]     CHAR (7)   NOT NULL,
    [BTb0Nom]     CHAR (50)  NULL,
    [BTb0DtC]     DATETIME   NULL,
    [BTb0DtV]     DATETIME   NULL,
    [BTb0Ref]     CHAR (100) NULL,
    [BTb0Atv]     CHAR (1)   NULL,
    PRIMARY KEY CLUSTERED ([BTb0ForCnpj] ASC, [BTb0Cod] ASC)
);

