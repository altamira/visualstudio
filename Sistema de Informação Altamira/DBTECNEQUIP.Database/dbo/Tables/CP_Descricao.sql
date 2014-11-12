CREATE TABLE [dbo].[CP_Descricao] (
    [cpde_Tipo]      CHAR (1)   NOT NULL,
    [cpde_Codigo]    SMALLINT   NOT NULL,
    [cpde_Descricao] CHAR (40)  NOT NULL,
    [cpde_Lock]      ROWVERSION NOT NULL,
    CONSTRAINT [PK_CP_Descricao] PRIMARY KEY NONCLUSTERED ([cpde_Tipo] ASC, [cpde_Codigo] ASC) WITH (FILLFACTOR = 90)
);

