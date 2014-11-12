CREATE TABLE [dbo].[Grupo_Mapa_Policia] (
    [cd_grupo_mapa_policia] INT          NOT NULL,
    [nm_grupo_mapa_policia] VARCHAR (40) NULL,
    [sg_grupo_mapa_policia] CHAR (10)    NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Grupo_Mapa_Policia] PRIMARY KEY CLUSTERED ([cd_grupo_mapa_policia] ASC) WITH (FILLFACTOR = 90)
);

