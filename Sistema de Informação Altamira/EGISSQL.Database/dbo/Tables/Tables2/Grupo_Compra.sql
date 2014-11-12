CREATE TABLE [dbo].[Grupo_Compra] (
    [cd_grupo_compra]         INT          NOT NULL,
    [nm_grupo_compra]         VARCHAR (40) NULL,
    [sg_grupo_compra]         CHAR (10)    NULL,
    [cd_mascara_grupo_compra] VARCHAR (20) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Grupo_Compra] PRIMARY KEY CLUSTERED ([cd_grupo_compra] ASC) WITH (FILLFACTOR = 90)
);

