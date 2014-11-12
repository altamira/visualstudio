﻿CREATE TABLE [dbo].[Requisicao_Compra_Item] (
    [cd_requisicao_compra]       INT          NOT NULL,
    [cd_item_requisicao_compra]  INT          NOT NULL,
    [cd_produto]                 INT          NULL,
    [qt_item_requisicao_compra]  FLOAT (53)   NULL,
    [cd_servico]                 INT          NULL,
    [ds_item_requisicao_compra]  TEXT         NULL,
    [nm_prod_requisicao_compra]  VARCHAR (50) NULL,
    [cd_pedido_venda]            INT          NULL,
    [cd_item_pedido_venda]       INT          NULL,
    [cd_unidade_medida]          INT          NULL,
    [qt_liq_requisicao_compra]   FLOAT (53)   NULL,
    [nm_obs_item_req_compra]     VARCHAR (50) NULL,
    [ic_gera_coto_item_req_com]  CHAR (1)     NULL,
    [ic_pedido_item_req_compra]  CHAR (1)     NULL,
    [nm_marca_item_req_compra]   VARCHAR (20) NULL,
    [cd_categoria_produto]       INT          NULL,
    [cd_maquina]                 INT          NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [nm_unidade_medida]          VARCHAR (20) NULL,
    [qt_liquido_req_compra]      FLOAT (53)   NULL,
    [qt_bruto_req_compra]        FLOAT (53)   NULL,
    [qt_peso_req_compra]         FLOAT (53)   NULL,
    [cd_item_pedido_compra]      INT          NULL,
    [cd_pedido_compra]           INT          NULL,
    [dt_item_nec_req_compra]     DATETIME     NULL,
    [ic_gerado_cot_req_compra]   CHAR (1)     NULL,
    [cd_mascara_produto]         VARCHAR (20) NULL,
    [cd_tipo_placa]              INT          NULL,
    [cd_Mat_prima]               INT          NULL,
    [ic_redondo_Mat_prima]       CHAR (1)     NULL,
    [ic_tipo_placa_Mat_prima]    CHAR (1)     NULL,
    [nm_medacab_Mat_prima]       VARCHAR (30) NULL,
    [nm_medbruta_Mat_prima]      VARCHAR (30) NULL,
    [nm_medretif_Mat_prima]      VARCHAR (30) NULL,
    [qt_compacab_Mat_prima]      FLOAT (53)   NULL,
    [qt_compbruta_Mat_prima]     FLOAT (53)   NULL,
    [qt_compretif_Mat_prima]     FLOAT (53)   NULL,
    [qt_espesacab_Mat_prima]     FLOAT (53)   NULL,
    [qt_espesretif_Mat_prima]    FLOAT (53)   NULL,
    [qt_espesbruta_Mat_prima]    FLOAT (53)   NULL,
    [qt_item_Mat_prima]          FLOAT (53)   NULL,
    [qt_largacab_Mat_prima]      FLOAT (53)   NULL,
    [qt_largaretif_Mat_prima]    FLOAT (53)   NULL,
    [qt_largbruta_Mat_prima]     FLOAT (53)   NULL,
    [qt_tolcompacab_Mat_prima]   FLOAT (53)   NULL,
    [qt_tolcompret_Mat_prima]    FLOAT (53)   NULL,
    [qt_tolespesacab_Mat_prima]  FLOAT (53)   NULL,
    [qt_tolespesret_Mat_prima]   FLOAT (53)   NULL,
    [qt_tollargacab_Mat_prima]   FLOAT (53)   NULL,
    [qt_tollargret_Mat_prima]    FLOAT (53)   NULL,
    [cd_item_req_compra_mat_pr]  INT          NULL,
    [cd_mat_pri_req_com_mat_pr]  INT          NULL,
    [ic_redondo_req_com_mat_pr]  CHAR (1)     NULL,
    [ic_tipo_pla_req_com_ma_pr]  CHAR (1)     NULL,
    [nm_medacab_req_com_mat_pr]  VARCHAR (30) NULL,
    [nm_medbruta_req_com_ma_pr]  VARCHAR (30) NULL,
    [nm_medret_reg_comp_mat_pr]  VARCHAR (30) NULL,
    [qt_compac_req_comp_mat_pr]  FLOAT (53)   NULL,
    [qt_compbru_req_comp_ma_pr]  FLOAT (53)   NULL,
    [qt_compre_req_comp_mat_pr]  FLOAT (53)   NULL,
    [qt_espbrut_req_com_mat_pr]  FLOAT (53)   NULL,
    [qt_espessa_req_com_mat_pr]  FLOAT (53)   NULL,
    [qt_espre_req_comp_mat_pr]   FLOAT (53)   NULL,
    [qt_item_req_compra_mat_pr]  FLOAT (53)   NULL,
    [qt_largacab_req_com_ma_pr]  FLOAT (53)   NULL,
    [qt_largre_req_com_mate_pr]  FLOAT (53)   NULL,
    [qt_largur_req_comp_mat_pr]  FLOAT (53)   NULL,
    [qt_totcompac_req_co_ma_pr]  FLOAT (53)   NULL,
    [qt_totcore_req_com_mat_pr]  FLOAT (53)   NULL,
    [qt_totespaca_req_co_ma_pr]  FLOAT (53)   NULL,
    [qt_totesre_req_com_mat_pr]  FLOAT (53)   NULL,
    [qt_totlar_req_comp_mat_pr]  FLOAT (53)   NULL,
    [qt_totlarre_req_com_ma_pr]  FLOAT (53)   NULL,
    [ds_obs_req_compra_item]     TEXT         NULL,
    [cd_processo]                INT          NULL,
    [cd_plano_compra]            INT          NULL,
    [cd_plano_financeiro]        INT          NULL,
    [nm_placa]                   VARCHAR (18) NULL,
    [cd_item_ped_imp]            INT          NULL,
    [cd_pedido_importacao]       INT          NULL,
    [cd_placa]                   INT          NULL,
    [cd_pais]                    INT          NULL,
    [cd_pais_procedencia]        INT          NULL,
    [cd_ordem_servico]           INT          NULL,
    [cd_item_ordem_servico]      INT          NULL,
    [cd_veiculo]                 INT          NULL,
    [cd_desenho_item_requisicao] VARCHAR (30) NULL,
    [cd_rev_des_item_requisicao] VARCHAR (5)  NULL,
    [cd_centro_custo]            INT          NULL,
    [ic_item_orcamento_compra]   CHAR (1)     NULL,
    [cd_contrato_compra]         INT          NULL,
    [cd_programacao_entrega]     INT          NULL,
    [cd_consulta]                INT          NULL,
    [cd_item_consulta]           INT          NULL,
    [cd_plano_mrp]               INT          NULL,
    CONSTRAINT [PK_Requisicao_Compra_Item] PRIMARY KEY CLUSTERED ([cd_requisicao_compra] ASC, [cd_item_requisicao_compra] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_Requisicao_Compra_Item_Produto]
    ON [dbo].[Requisicao_Compra_Item]([cd_produto] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Requisicao_Compra_Item]
    ON [dbo].[Requisicao_Compra_Item]([dt_item_nec_req_compra] ASC) WITH (FILLFACTOR = 90);

