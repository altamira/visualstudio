CREATE TABLE [dbo].[Disciplina_Grade] (
    [cd_curso]                 INT        NOT NULL,
    [cd_disciplina]            INT        NOT NULL,
    [qt_hora_disciplina_grade] FLOAT (53) NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    CONSTRAINT [PK_Disciplina_Grade] PRIMARY KEY CLUSTERED ([cd_curso] ASC, [cd_disciplina] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Disciplina_Grade_Disciplina] FOREIGN KEY ([cd_disciplina]) REFERENCES [dbo].[Disciplina] ([cd_disciplina])
);

