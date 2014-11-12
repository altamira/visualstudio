CREATE TABLE [dbo].[PRE_CategoriaMP] (
    [ctmp_Codigo]    NVARCHAR (3)  NOT NULL,
    [ctmp_Descricao] NVARCHAR (40) NULL,
    CONSTRAINT [PK_PRE_CategoriaMP] PRIMARY KEY NONCLUSTERED ([ctmp_Codigo] ASC) WITH (FILLFACTOR = 90)
);

