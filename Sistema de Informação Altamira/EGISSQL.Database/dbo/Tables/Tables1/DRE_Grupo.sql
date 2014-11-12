CREATE TABLE [dbo].[DRE_Grupo] (
    [cd_dre_grupo]         INT          NOT NULL,
    [nm_dre_grupo]         VARCHAR (40) NULL,
    [sg_dre_grupo]         CHAR (10)    NULL,
    [qt_ordem_dre_grupo]   INT          NULL,
    [ds_dre_grupo]         TEXT         NULL,
    [cd_procedimento]      INT          NULL,
    [ic_ativo_dre_grupo]   CHAR (1)     NULL,
    [ic_soma_dre_grupo]    CHAR (1)     NULL,
    [cd_dre_tipo]          INT          NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [cd_mascara_dre_grupo] VARCHAR (20) NULL,
    [ic_negrito_dre_grupo] CHAR (1)     NULL,
    [ic_traco_dre_grupo]   CHAR (1)     NULL,
    CONSTRAINT [PK_DRE_Grupo] PRIMARY KEY CLUSTERED ([cd_dre_grupo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_DRE_Grupo_DRE_Tipo] FOREIGN KEY ([cd_dre_tipo]) REFERENCES [dbo].[DRE_Tipo] ([cd_dre_tipo])
);

