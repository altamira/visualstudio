CREATE TABLE [dbo].[Modelo_Treinamento] (
    [cd_modelo_treinamento] INT          NOT NULL,
    [nm_modelo_treinamento] VARCHAR (40) NULL,
    [sg_modelo_treinamento] CHAR (10)    NULL,
    [dt_modelo_treinamento] DATETIME     NULL,
    [ds_modelo_treinamento] TEXT         NULL,
    [qt_dia_modelo]         INT          NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Modelo_Treinamento] PRIMARY KEY CLUSTERED ([cd_modelo_treinamento] ASC) WITH (FILLFACTOR = 90)
);

