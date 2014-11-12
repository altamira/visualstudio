CREATE TABLE [dbo].[Tipo_Ferramenta_Cam] (
    [cd_tipo_ferramenta_cam] INT          NOT NULL,
    [nm_tipo_ferramenta_cam] VARCHAR (30) COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [sg_tipo_ferramenta]     VARCHAR (5)  COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [cd_usuario]             INT          NOT NULL,
    [dt_usuario]             DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Ferramenta_Cam] PRIMARY KEY CLUSTERED ([cd_tipo_ferramenta_cam] ASC) WITH (FILLFACTOR = 90)
);

