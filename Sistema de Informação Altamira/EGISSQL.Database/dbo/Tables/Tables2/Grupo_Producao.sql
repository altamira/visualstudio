CREATE TABLE [dbo].[Grupo_Producao] (
    [cd_grupo_producao]         INT          NOT NULL,
    [nm_grupo_producao]         VARCHAR (40) NULL,
    [sg_grupo_producao]         CHAR (10)    NULL,
    [cd_mascara_grupo_producao] VARCHAR (20) NULL,
    [ic_mostra_grupo_producao]  CHAR (1)     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Grupo_Producao] PRIMARY KEY CLUSTERED ([cd_grupo_producao] ASC) WITH (FILLFACTOR = 90)
);

