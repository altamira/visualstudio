CREATE TABLE [dbo].[TMAPR1] (
    [TCmpId]  DECIMAL (14)    NOT NULL,
    [TCmpCod] CHAR (7)        NOT NULL,
    [TCmpNom] CHAR (40)       NULL,
    [TCmpUni] CHAR (2)        NULL,
    [TCmpQtd] DECIMAL (11, 4) NULL,
    PRIMARY KEY CLUSTERED ([TCmpId] ASC, [TCmpCod] ASC)
);

