CREATE TABLE [dbo].[Grupo_Regiao] (
    [cd_grupo_regiao] INT          NOT NULL,
    [nm_grupo_regiao] VARCHAR (40) NULL,
    [sg_grupo_regiao] CHAR (10)    NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Grupo_Regiao] PRIMARY KEY CLUSTERED ([cd_grupo_regiao] ASC) WITH (FILLFACTOR = 90)
);

