CREATE TABLE [dbo].[Motivo_Situacao_Aluno] (
    [cd_motivo_situacao] INT          NOT NULL,
    [nm_motivo_situacao] VARCHAR (40) NULL,
    [sg_motivo_situacao] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Situacao_Aluno] PRIMARY KEY CLUSTERED ([cd_motivo_situacao] ASC) WITH (FILLFACTOR = 90)
);

