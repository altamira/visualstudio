CREATE TABLE [dbo].[Grupo_Plano_Controle] (
    [cd_grupo_plano_controle] INT          NOT NULL,
    [nm_grupo_plano_controle] VARCHAR (40) NULL,
    [sg_grupo_plano_controle] CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Grupo_Plano_Controle] PRIMARY KEY CLUSTERED ([cd_grupo_plano_controle] ASC) WITH (FILLFACTOR = 90)
);

