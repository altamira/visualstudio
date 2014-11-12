CREATE TABLE [dbo].[Grupo_Empresa] (
    [cd_grupo_empresa]         INT          NOT NULL,
    [nm_grupo_empresa]         VARCHAR (40) NULL,
    [sg_grupo_empresa]         CHAR (10)    NULL,
    [nm_mascara_grupo_empresa] VARCHAR (20) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Grupo_Empresa] PRIMARY KEY CLUSTERED ([cd_grupo_empresa] ASC) WITH (FILLFACTOR = 90)
);

