CREATE TABLE [dbo].[Grupo_Caracteristica_Amostra] (
    [cd_grupo_caracteristica] INT          NOT NULL,
    [nm_grupo_caracteristica] VARCHAR (50) NOT NULL,
    [sg_grupo_caracteristica] CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_ordem_apresentacao]   INT          NULL,
    CONSTRAINT [PK_Grupo_Caracteristica_Amostra] PRIMARY KEY CLUSTERED ([cd_grupo_caracteristica] ASC) WITH (FILLFACTOR = 90)
);

