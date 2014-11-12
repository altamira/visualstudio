CREATE TABLE [dbo].[Aluno_Acesso] (
    [cd_aluno_acesso] INT      NOT NULL,
    [cd_aluno]        INT      NOT NULL,
    [dt_acesso]       DATETIME NOT NULL,
    [cd_tipo_sala]    INT      NULL,
    [ic_tipo_acesso]  CHAR (1) NULL,
    [cd_usuario]      INT      NULL,
    [dt_usuario]      DATETIME NULL,
    CONSTRAINT [PK_Aluno_Acesso] PRIMARY KEY CLUSTERED ([cd_aluno_acesso] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Aluno_Acesso_Tipo_Sala] FOREIGN KEY ([cd_tipo_sala]) REFERENCES [dbo].[Tipo_Sala] ([cd_tipo_sala])
);

