CREATE TABLE [dbo].[FN_Funcao] (
    [fnfu_Codigo]    CHAR (3)     NOT NULL,
    [fnfu_Descricao] VARCHAR (50) NULL,
    CONSTRAINT [PK_FN_Funcao] PRIMARY KEY NONCLUSTERED ([fnfu_Codigo] ASC) WITH (FILLFACTOR = 90)
);

