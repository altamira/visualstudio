CREATE TABLE [dbo].[CL_Estados] (
    [clesNome]  CHAR (20)  NOT NULL,
    [clesSigla] CHAR (2)   NOT NULL,
    [clesICMS]  FLOAT (53) NULL,
    CONSTRAINT [PK_CL_Estados] PRIMARY KEY NONCLUSTERED ([clesSigla] ASC) WITH (FILLFACTOR = 90)
);

