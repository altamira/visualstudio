CREATE TABLE [dbo].[PRE_OrcaDescSituação] (
    [Codigo]    SMALLINT     NOT NULL,
    [Descrição] VARCHAR (50) NULL,
    [Situação]  INT          NULL,
    CONSTRAINT [PK_PRE_SItuaçãoOrca] PRIMARY KEY NONCLUSTERED ([Codigo] ASC) WITH (FILLFACTOR = 90)
);

