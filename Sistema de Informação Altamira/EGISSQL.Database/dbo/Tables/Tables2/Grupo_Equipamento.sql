CREATE TABLE [dbo].[Grupo_Equipamento] (
    [cd_grupo_equipamento] INT          NOT NULL,
    [nm_grupo_equipamento] VARCHAR (40) NULL,
    [sg_grupo_equipamento] CHAR (10)    NULL,
    [cd_mascara_grupo]     VARCHAR (20) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Grupo_Equipamento] PRIMARY KEY CLUSTERED ([cd_grupo_equipamento] ASC) WITH (FILLFACTOR = 90)
);

