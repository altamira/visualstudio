CREATE TABLE [dbo].[Disciplina] (
    [cd_disciplina]       INT          NOT NULL,
    [nm_disciplina]       VARCHAR (40) NULL,
    [sg_disciplina]       CHAR (10)    NULL,
    [qt_ordem_disciplina] INT          NULL,
    [ic_ativo_disciplina] CHAR (1)     NULL,
    [qt_hora_disciplina]  FLOAT (53)   NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Disciplina] PRIMARY KEY CLUSTERED ([cd_disciplina] ASC) WITH (FILLFACTOR = 90)
);

