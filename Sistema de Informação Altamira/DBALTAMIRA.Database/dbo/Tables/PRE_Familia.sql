CREATE TABLE [dbo].[PRE_Familia] (
    [prfa_Familia]   CHAR (10)  NOT NULL,
    [prfa_Descrição] CHAR (40)  NULL,
    [prfa_IPI]       FLOAT (53) NULL,
    CONSTRAINT [PK_PRE_Familia] PRIMARY KEY NONCLUSTERED ([prfa_Familia] ASC) WITH (FILLFACTOR = 90)
);

