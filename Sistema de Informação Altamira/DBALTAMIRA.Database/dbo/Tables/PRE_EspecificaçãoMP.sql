CREATE TABLE [dbo].[PRE_EspecificaçãoMP] (
    [esmp_Codigo]    NVARCHAR (5)  NOT NULL,
    [esmp_Descrição] NVARCHAR (30) NULL,
    CONSTRAINT [PK_PRE_EspecificaçãoMP] PRIMARY KEY NONCLUSTERED ([esmp_Codigo] ASC) WITH (FILLFACTOR = 90)
);

