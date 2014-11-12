CREATE TABLE [dbo].[Dr_Grupo_Composicao] (
    [cd_dr_grupo]              INT          NOT NULL,
    [cd_item_dr_grupo]         INT          NOT NULL,
    [nm_item_dr_grupo]         VARCHAR (40) NULL,
    [qt_ordem_item_dr_grupo]   INT          NULL,
    [ic_soma_item_dr_grupo]    CHAR (1)     NULL,
    [ic_digita_item_dr_grupo]  CHAR (1)     NULL,
    [ic_negrito_item_dr_grupo] CHAR (1)     NULL,
    [ic_total_item_dr_grupo]   CHAR (1)     NULL,
    [cd_procedimento]          INT          NULL,
    [nm_obs_item_dr_grupo]     VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [ic_mostra_item_dr_grupo]  CHAR (1)     NULL,
    [cd_mascara_item_dr_grupo] VARCHAR (20) NULL,
    [ic_traco_item_dr_grupo]   CHAR (1)     NULL,
    CONSTRAINT [PK_Dr_Grupo_Composicao] PRIMARY KEY CLUSTERED ([cd_dr_grupo] ASC, [cd_item_dr_grupo] ASC) WITH (FILLFACTOR = 90)
);

