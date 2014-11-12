CREATE TABLE [dbo].[Entidade_Ensino_Curso] (
    [cd_entidade_ensino] INT      NOT NULL,
    [cd_curso]           INT      NOT NULL,
    [cd_usuario]         INT      NULL,
    [dt_usuario]         DATETIME NULL,
    CONSTRAINT [PK_Entidade_Ensino_Curso] PRIMARY KEY CLUSTERED ([cd_entidade_ensino] ASC, [cd_curso] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Entidade_Ensino_Curso_Entidade_Ensino] FOREIGN KEY ([cd_entidade_ensino]) REFERENCES [dbo].[Entidade_Ensino] ([cd_entidade_ensino])
);

