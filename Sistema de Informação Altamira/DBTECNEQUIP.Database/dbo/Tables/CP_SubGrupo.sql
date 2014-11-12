CREATE TABLE [dbo].[CP_SubGrupo] (
    [cpsg_Codigo]    TINYINT    NOT NULL,
    [cpsg_Descricao] CHAR (30)  NOT NULL,
    [cpsg_Grupo]     TINYINT    NOT NULL,
    [cpsg_Lock]      ROWVERSION NOT NULL,
    CONSTRAINT [PK_CP_SubGrupo] PRIMARY KEY NONCLUSTERED ([cpsg_Codigo] ASC, [cpsg_Grupo] ASC) WITH (FILLFACTOR = 90)
);

