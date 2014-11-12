CREATE TABLE [dbo].[Tipo_Treinamento] (
    [cd_tipo_treinamento] INT          NOT NULL,
    [nm_tipo_treinamento] VARCHAR (40) NULL,
    [sg_tipo_treinamento] CHAR (10)    NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Treinamento] PRIMARY KEY CLUSTERED ([cd_tipo_treinamento] ASC) WITH (FILLFACTOR = 90)
);

