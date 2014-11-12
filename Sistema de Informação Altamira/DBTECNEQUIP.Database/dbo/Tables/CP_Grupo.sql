CREATE TABLE [dbo].[CP_Grupo] (
    [cpgr_CodigoGrupo]    TINYINT    NOT NULL,
    [cpgr_DescricaoGrupo] CHAR (30)  NOT NULL,
    [cpgr_Lock]           ROWVERSION NOT NULL,
    CONSTRAINT [PK_CP_Grupo] PRIMARY KEY NONCLUSTERED ([cpgr_CodigoGrupo] ASC) WITH (FILLFACTOR = 90)
);

