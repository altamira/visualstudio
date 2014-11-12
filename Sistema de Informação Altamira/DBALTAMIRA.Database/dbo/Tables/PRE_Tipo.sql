CREATE TABLE [dbo].[PRE_Tipo] (
    [prti_Codigo]    FLOAT (53)    NOT NULL,
    [prti_Descrição] NVARCHAR (40) NULL,
    CONSTRAINT [PK_PRE_Tipo] PRIMARY KEY NONCLUSTERED ([prti_Codigo] ASC) WITH (FILLFACTOR = 90)
);

