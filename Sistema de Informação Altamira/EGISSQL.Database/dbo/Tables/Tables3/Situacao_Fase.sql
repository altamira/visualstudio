CREATE TABLE [dbo].[Situacao_Fase] (
    [cd_situacao_fase] INT          NOT NULL,
    [nm_situacao_fase] VARCHAR (50) NULL,
    [sg_situacao_fase] CHAR (10)    NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Situacao_Fase] PRIMARY KEY CLUSTERED ([cd_situacao_fase] ASC) WITH (FILLFACTOR = 90)
);

