CREATE TABLE [dbo].[VE_Tipos] (
    [Codigo]    SMALLINT     NOT NULL,
    [Descrição] VARCHAR (50) NULL,
    [Situação]  INT          NULL,
    CONSTRAINT [PK_VE_Tipos] PRIMARY KEY NONCLUSTERED ([Codigo] ASC) WITH (FILLFACTOR = 90)
);

