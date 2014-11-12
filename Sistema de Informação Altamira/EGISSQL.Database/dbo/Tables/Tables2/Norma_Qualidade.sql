CREATE TABLE [dbo].[Norma_Qualidade] (
    [cd_norma_qualidade]     INT           NOT NULL,
    [cd_grupo_norma]         INT           NOT NULL,
    [nm_norma_qualidade]     VARCHAR (60)  NULL,
    [cd_mascara_norma]       VARCHAR (20)  NULL,
    [sg_norma_qualidade]     CHAR (10)     NULL,
    [nm_ref_norma_qualidade] VARCHAR (15)  NULL,
    [ds_norma_qualidade]     TEXT          NULL,
    [nm_caminho_norma]       VARCHAR (100) NULL,
    [cd_usuario]             INT           NULL,
    [dt_usuario]             DATETIME      NULL,
    CONSTRAINT [PK_Norma_Qualidade] PRIMARY KEY CLUSTERED ([cd_norma_qualidade] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Norma_Qualidade_Grupo_Norma_Qualidade] FOREIGN KEY ([cd_grupo_norma]) REFERENCES [dbo].[Grupo_Norma_Qualidade] ([cd_grupo_norma])
);

