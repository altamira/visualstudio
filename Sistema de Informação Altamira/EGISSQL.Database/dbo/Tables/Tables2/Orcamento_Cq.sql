﻿CREATE TABLE [dbo].[Orcamento_Cq] (
    [cd_consulta]                INT           NOT NULL,
    [cd_item_consulta]           INT           NOT NULL,
    [nm_produto_cliente]         VARCHAR (40)  NOT NULL,
    [qt_peso_produto_consulta]   FLOAT (53)    NOT NULL,
    [ic_desenho_produto]         CHAR (1)      NULL,
    [nm_caminho_desenho]         VARCHAR (100) NULL,
    [ic_amostra_consulta]        CHAR (1)      NULL,
    [qt_espessura_parede]        FLOAT (53)    NULL,
    [qt_espessura_ponto_injecao] FLOAT (53)    NULL,
    [qt_distancia_centros]       FLOAT (53)    NULL,
    [ds_ponto_injecao_consulta]  TEXT          NULL,
    [ic_carga_consulta]          CHAR (1)      NULL,
    [pc_talco_consulta]          FLOAT (53)    NULL,
    [pc_fibra_vidro_consulta]    FLOAT (53)    NULL,
    [ic_troca_cor_consulta]      CHAR (1)      NULL,
    [ic_desenho_molde_consulta]  CHAR (1)      NULL,
    [nm_caminho_desenho_molde]   VARCHAR (100) NULL,
    [ic_tipo_molde_consulta]     CHAR (1)      NULL,
    [qt_cavidade_consulta]       INT           NULL,
    [qt_bucha_consulta]          FLOAT (53)    NULL,
    [qt_diametro_anel_consulta]  FLOAT (53)    NULL,
    [qt_raio_bucha_consulta]     FLOAT (53)    NULL,
    [ic_elimina_galho_consulta]  CHAR (1)      NULL,
    [qt_angulo_acopla_consulta]  FLOAT (53)    NULL,
    [ds_observacao_produto]      TEXT          NULL,
    [ds_aplicacao_produto]       TEXT          NULL,
    [cd_material_plastico]       INT           NULL,
    [nm_comp_material_plastico]  VARCHAR (20)  NULL,
    [qt_espessura_molde_cq]      FLOAT (53)    NULL,
    [qt_largura_molde_cq]        FLOAT (53)    NULL,
    [qt_comprimento_molde_cq]    FLOAT (53)    NULL,
    [vl_total_orcamento_cq]      FLOAT (53)    NULL,
    [vl_porta_molde_cq]          FLOAT (53)    NULL,
    [vl_acessorios_orcamento]    FLOAT (53)    NULL,
    [ic_porta_molde_cq]          CHAR (1)      NULL,
    [cd_produto_padrao_cq]       CHAR (9)      NULL,
    [cd_tipo_sistema]            INT           NULL,
    [cd_usuario]                 INT           NULL,
    [dt_usuario]                 DATETIME      NULL,
    [qt_tempo_projeto]           INT           NULL,
    [dt_orcamento_consulta]      DATETIME      NULL,
    [ic_liberado_orcamento]      CHAR (1)      NULL,
    [dt_liberacao_orcamento]     DATETIME      NULL,
    [ic_cota_ct]                 CHAR (1)      NULL,
    [qt_zonas_controlador]       INT           NULL,
    [qt_comprimento_bico]        FLOAT (53)    NULL,
    [cd_dias_uteis_entrega]      INT           NULL,
    [cd_ordem_servico_cliente]   VARCHAR (20)  NULL,
    [ic_cota_placa_hot_runner]   CHAR (1)      NULL,
    [ds_distancia_centros_y]     TEXT          NULL,
    [qt_distancia_centros_y]     FLOAT (53)    NULL,
    [qt_bicos_cavidade]          INT           NULL,
    [qt_peso_bruto_string]       VARCHAR (20)  NULL,
    [qt_cavidade_string]         VARCHAR (10)  NULL,
    CONSTRAINT [PK_Orcamento_Cq] PRIMARY KEY NONCLUSTERED ([cd_consulta] ASC, [cd_item_consulta] ASC) WITH (FILLFACTOR = 90)
);

