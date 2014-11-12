CREATE TABLE [dbo].[Parametro_Analise_SCR] (
    [cd_parametro_analise_scr] INT          NOT NULL,
    [qt_inicial]               INT          NULL,
    [qt_final]                 INT          NULL,
    [nm_parametro_analise_scr] VARCHAR (40) NULL,
    [qt_ordem]                 INT          NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Parametro_Analise_SCR] PRIMARY KEY CLUSTERED ([cd_parametro_analise_scr] ASC) WITH (FILLFACTOR = 90)
);

