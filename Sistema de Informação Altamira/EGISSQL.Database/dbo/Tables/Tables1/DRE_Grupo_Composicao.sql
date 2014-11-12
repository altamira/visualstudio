CREATE TABLE [dbo].[DRE_Grupo_Composicao] (
    [cd_dre_grupo]              INT          NOT NULL,
    [cd_item_dre_grupo]         INT          NOT NULL,
    [nm_item_dre_grupo]         VARCHAR (40) NULL,
    [qt_ordem_item_dre_grupo]   INT          NULL,
    [ic_soma_item_dre_grupo]    CHAR (1)     NULL,
    [ic_digita_item_dre_grupo]  CHAR (1)     NULL,
    [ic_negrito_dre_grupo]      CHAR (1)     NULL,
    [ic_total_item_dre_grupo]   CHAR (1)     NULL,
    [cd_procedimento]           INT          NULL,
    [nm_obs_item_dre_grupo]     VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_mostra_item_dre_grupo]  CHAR (1)     NULL,
    [cd_mascara_item_dre_grupo] VARCHAR (20) NULL,
    [ic_traco_item_dre_grupo]   CHAR (1)     NULL,
    CONSTRAINT [PK_DRE_Grupo_Composicao] PRIMARY KEY CLUSTERED ([cd_dre_grupo] ASC, [cd_item_dre_grupo] ASC) WITH (FILLFACTOR = 90)
);

