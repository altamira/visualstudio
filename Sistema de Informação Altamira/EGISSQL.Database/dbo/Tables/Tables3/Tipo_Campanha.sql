CREATE TABLE [dbo].[Tipo_Campanha] (
    [cd_tipo_campanha] INT          NOT NULL,
    [nm_tipo_campanha] VARCHAR (30) NOT NULL,
    [sg_tipo_campanha] VARCHAR (10) NOT NULL,
    [cd_usuario]       INT          NOT NULL,
    [dt_usuario]       DATETIME     NOT NULL
);

