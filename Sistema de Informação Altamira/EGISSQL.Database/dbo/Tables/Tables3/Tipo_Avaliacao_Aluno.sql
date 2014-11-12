CREATE TABLE [dbo].[Tipo_Avaliacao_Aluno] (
    [cd_tipo_avaliacao] INT          NOT NULL,
    [nm_tipo_avaliacao] VARCHAR (40) NULL,
    [sg_tipo_avaliacao] CHAR (10)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Avaliacao_Aluno] PRIMARY KEY CLUSTERED ([cd_tipo_avaliacao] ASC) WITH (FILLFACTOR = 90)
);

