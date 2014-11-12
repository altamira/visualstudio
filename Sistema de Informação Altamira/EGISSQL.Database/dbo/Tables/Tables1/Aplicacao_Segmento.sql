CREATE TABLE [dbo].[Aplicacao_Segmento] (
    [cd_aplicacao_segmento] INT          NOT NULL,
    [nm_aplicacao_segmento] VARCHAR (30) NOT NULL,
    [sg_aplicacao_segmento] CHAR (10)    NOT NULL,
    [cd_usuario]            INT          NOT NULL,
    [dt_usuario]            DATETIME     NOT NULL,
    CONSTRAINT [PK_Aplicacao_Segmento] PRIMARY KEY CLUSTERED ([cd_aplicacao_segmento] ASC) WITH (FILLFACTOR = 90)
);

