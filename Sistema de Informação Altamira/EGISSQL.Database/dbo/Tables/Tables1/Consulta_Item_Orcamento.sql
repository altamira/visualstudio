﻿CREATE TABLE [dbo].[Consulta_Item_Orcamento] (
    [cd_consulta]               INT          NOT NULL,
    [cd_item_consulta]          INT          NOT NULL,
    [dt_orcamento_consulta]     DATETIME     NULL,
    [cd_item_orcamento]         INT          NULL,
    [cd_produto]                INT          NULL,
    [cd_placa]                  INT          NULL,
    [cd_ordem_item_orcamento]   INT          NULL,
    [qt_item_orcamento]         FLOAT (53)   NULL,
    [qt_pesliq_item_orcamento]  FLOAT (53)   NULL,
    [qt_pesbru_item_orcamento]  FLOAT (53)   NULL,
    [cd_materia_prima]          INT          NULL,
    [nm_obs_item_orcamento]     VARCHAR (40) NULL,
    [ic_compra_item_orcamento]  CHAR (1)     NULL,
    [cd_categoria_produto]      INT          NULL,
    [ic_agserv_item_orcamento]  CHAR (1)     NULL,
    [ic_furadi_item_orcamento]  CHAR (1)     NULL,
    [ic_refrig_item_orcamento]  CHAR (1)     NULL,
    [ic_gancho_item_orcamento]  CHAR (1)     NULL,
    [ic_aloj_item_orcamento]    CHAR (1)     NULL,
    [ic_acab_item_orcamento]    CHAR (1)     NULL,
    [nm_medacab_item_orcamento] VARCHAR (30) NULL,
    [qt_espac_item_orcamento]   FLOAT (53)   NULL,
    [qt_largac_item_orcamento]  FLOAT (53)   NULL,
    [qt_compac_item_orcamento]  FLOAT (53)   NULL,
    [nm_medbru_item_orcamento]  VARCHAR (30) NULL,
    [qt_espbru_item_orcamento]  FLOAT (53)   NULL,
    [qt_largbru_item_orcamento] FLOAT (53)   NULL,
    [qt_compbru_item_orcamento] FLOAT (53)   NULL,
    [qt_medtab_item_orcamento]  FLOAT (53)   NULL,
    [vl_custo_item_orcamento]   FLOAT (53)   NULL,
    [vl_prod_item_orcamento]    FLOAT (53)   NULL,
    [qt_furfix_item_orcamento]  INT          NULL,
    [qt_bc_item_orcamento]      INT          NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [qt_dbcags_item_orcamento]  FLOAT (53)   NULL,
    [qt_diambc_item_orcamento]  FLOAT (53)   NULL,
    [qt_velac_item_orcamento]   FLOAT (53)   NULL,
    [qt_velpac_item_orcamento]  FLOAT (53)   NULL,
    [cd_grupo_esquadro]         INT          NULL,
    [qt_bcags_item_orcamento]   FLOAT (53)   NULL,
    [qt_fuadic_item_orcamento]  FLOAT (53)   NULL,
    [qt_tpdabc_item_orcamento]  FLOAT (53)   NULL,
    [qt_comprg_item_orcamento]  FLOAT (53)   NULL,
    [qt_rasgo_item_orcamento]   FLOAT (53)   NULL,
    [ic_orcamento_status]       CHAR (1)     NULL,
    [ic_redondo_item_orcamento] CHAR (1)     NULL,
    [cd_tipo_placa]             INT          NULL,
    [cd_base_polimold]          VARCHAR (30) NULL,
    [cd_montagem]               INT          NULL,
    [pc_markup_mao_obra]        FLOAT (53)   NULL,
    [pc_markup_mat_prima]       FLOAT (53)   NULL,
    [pc_markup_componente]      FLOAT (53)   NULL,
    [vl_custo_mat_prima]        FLOAT (53)   NULL,
    [vl_prod_mat_prima]         FLOAT (53)   NULL,
    [vl_prod_mao_obra]          FLOAT (53)   NULL,
    [ic_base_especial_item_orc] CHAR (1)     NULL,
    [cd_base_concorrente]       VARCHAR (30) NULL,
    [qt_A1_item_orcamento]      INT          NULL,
    [qt_A2_item_orcamento]      INT          NULL,
    [qt_B1_item_orcamento]      INT          NULL,
    [qt_B2_item_orcamento]      INT          NULL,
    [qt_R_item_orcamento]       FLOAT (53)   NULL,
    [qt_F_item_orcamento]       FLOAT (53)   NULL,
    [qt_classe_folga_item_orc]  FLOAT (53)   NULL,
    [qt_L_item_orcamento]       INT          NULL,
    [qt_D2_item_orcamento]      INT          NULL,
    [qt_D1_item_orcamento]      INT          NULL,
    [qt_E2_item_orcamento]      INT          NULL,
    [qt_E1_item_orcamento]      INT          NULL,
    CONSTRAINT [PK_Consulta_Item_Orcamento] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_item_consulta] ASC) WITH (FILLFACTOR = 90)
);

