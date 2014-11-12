CREATE TABLE [dbo].[Tipo_Pesquisa] (
    [cd_tipo_pesquisa] INT          NOT NULL,
    [nm_tipo_pesquisa] VARCHAR (30) COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [sg_tipo_pesquisa] CHAR (10)    COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [cd_usuario]       INT          NOT NULL,
    [dt_usuario]       DATETIME     NOT NULL
);

