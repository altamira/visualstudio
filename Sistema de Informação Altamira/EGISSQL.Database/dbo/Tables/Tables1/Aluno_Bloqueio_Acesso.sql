CREATE TABLE [dbo].[Aluno_Bloqueio_Acesso] (
    [cd_aluno]                 INT          NOT NULL,
    [dt_bloqueio_acesso]       DATETIME     NULL,
    [cd_motivo_bloqueio]       INT          NULL,
    [nm_compl_bloqueio_acesso] VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Aluno_Bloqueio_Acesso] PRIMARY KEY CLUSTERED ([cd_aluno] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Aluno_Bloqueio_Acesso_Motivo_Bloqueio_Acesso] FOREIGN KEY ([cd_motivo_bloqueio]) REFERENCES [dbo].[Motivo_Bloqueio_Acesso] ([cd_motivo_bloqueio])
);

