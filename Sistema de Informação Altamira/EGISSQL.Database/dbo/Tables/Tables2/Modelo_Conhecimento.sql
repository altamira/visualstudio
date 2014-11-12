CREATE TABLE [dbo].[Modelo_Conhecimento] (
    [cd_modelo_conhecimento] INT          NOT NULL,
    [nm_modelo_conhecimento] VARCHAR (50) NULL,
    [sg_modelo_conhecimento] CHAR (10)    NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Modelo_Conhecimento] PRIMARY KEY CLUSTERED ([cd_modelo_conhecimento] ASC) WITH (FILLFACTOR = 90)
);

