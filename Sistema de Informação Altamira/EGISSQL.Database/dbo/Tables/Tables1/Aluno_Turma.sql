CREATE TABLE [dbo].[Aluno_Turma] (
    [cd_aluno]          INT      NOT NULL,
    [cd_turma]          INT      NOT NULL,
    [cd_usuario]        INT      NULL,
    [dt_usuario]        DATETIME NULL,
    [cd_situacao_turma] INT      NULL,
    CONSTRAINT [PK_Aluno_Turma] PRIMARY KEY CLUSTERED ([cd_aluno] ASC, [cd_turma] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Aluno_Turma_Turma] FOREIGN KEY ([cd_turma]) REFERENCES [dbo].[Turma] ([cd_turma])
);

