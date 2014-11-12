CREATE TABLE [dbo].[Grupo_Beneficio] (
    [cd_grupo_beneficio] INT          NOT NULL,
    [nm_grupo_beneficio] VARCHAR (40) NULL,
    [nm_fantasia_grupo]  VARCHAR (15) NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Grupo_Beneficio] PRIMARY KEY CLUSTERED ([cd_grupo_beneficio] ASC) WITH (FILLFACTOR = 90)
);

