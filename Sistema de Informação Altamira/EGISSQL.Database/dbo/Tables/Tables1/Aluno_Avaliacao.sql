CREATE TABLE [dbo].[Aluno_Avaliacao] (
    [cd_aluno]                  INT          NOT NULL,
    [cd_tipo_avaliacao]         INT          NOT NULL,
    [qt_dia_validade_avaliacao] INT          NULL,
    [dt_vencimento_avaliacao]   DATETIME     NULL,
    [nm_obs_avaliacao]          VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Aluno_Avaliacao] PRIMARY KEY CLUSTERED ([cd_aluno] ASC, [cd_tipo_avaliacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Aluno_Avaliacao_Tipo_Avaliacao_Aluno] FOREIGN KEY ([cd_tipo_avaliacao]) REFERENCES [dbo].[Tipo_Avaliacao_Aluno] ([cd_tipo_avaliacao])
);

