CREATE TABLE [dbo].[Grupo_Norma_Qualidade] (
    [cd_grupo_norma]         INT           NOT NULL,
    [nm_grupo_norma]         VARCHAR (60)  NULL,
    [sg_grupo_norma]         CHAR (10)     NULL,
    [cd_mascara_grupo_norma] VARCHAR (20)  NULL,
    [nm_ref_grupo_norma]     VARCHAR (15)  NULL,
    [ds_grupo_norma]         TEXT          NULL,
    [cd_usuario]             INT           NULL,
    [dt_usuario]             DATETIME      NULL,
    [nm_caminho_grupo]       VARCHAR (100) NULL,
    CONSTRAINT [PK_Grupo_Norma_Qualidade] PRIMARY KEY CLUSTERED ([cd_grupo_norma] ASC) WITH (FILLFACTOR = 90)
);

