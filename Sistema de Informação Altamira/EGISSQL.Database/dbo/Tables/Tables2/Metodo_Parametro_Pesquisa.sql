CREATE TABLE [dbo].[Metodo_Parametro_Pesquisa] (
    [cd_metodo_parametro_pesquisa] INT          NOT NULL,
    [nm_metodo_parametro_pesquisa] VARCHAR (50) NOT NULL,
    [sg_metodo_parametro_pesquisa] CHAR (10)    NULL,
    [cd_usuario]                   INT          NULL,
    [dt_usuario]                   DATETIME     NULL,
    CONSTRAINT [PK_Metodo_Parametro_Pesquisa] PRIMARY KEY CLUSTERED ([cd_metodo_parametro_pesquisa] ASC) WITH (FILLFACTOR = 90)
);

