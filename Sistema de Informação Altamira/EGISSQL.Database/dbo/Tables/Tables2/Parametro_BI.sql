﻿CREATE TABLE [dbo].[Parametro_BI] (
    [cd_empresa]                INT        NOT NULL,
    [cd_usuario]                INT        NOT NULL,
    [dt_usuario]                DATETIME   NOT NULL,
    [pc_bns]                    FLOAT (53) NULL,
    [cd_aplicacao_markup_venda] INT        NULL,
    [cd_aplicacao_markup_fat]   INT        NULL,
    [ic_imposto_bi]             CHAR (1)   NULL,
    [ic_consignacao_bi]         CHAR (1)   NULL,
    [ic_devolucao_bi]           CHAR (1)   NULL,
    [ic_frete_bi]               CHAR (1)   NULL,
    [ic_venda_liquido_bi]       CHAR (1)   NULL,
    [ic_fat_liquido_bi]         CHAR (1)   NULL,
    [ic_origem_custo]           CHAR (1)   NULL,
    [ic_ipi_vendas]             CHAR (1)   NULL,
    [ic_conversao_qtd_fator]    CHAR (1)   NULL,
    [ic_selecao_mercado]        CHAR (1)   NULL,
    [qt_item_pedido_bi]         INT        NULL,
    [ic_ipi_resumo_faturamento] CHAR (1)   NULL,
    [ic_comparativo]            CHAR (1)   NULL,
    [ic_margem]                 CHAR (1)   NULL,
    [ic_vendedor_mov_caixa]     CHAR (1)   NULL,
    [ic_tipo_atendimento]       CHAR (1)   NULL,
    [ic_bns]                    CHAR (1)   NULL,
    [ic_impostos_previsao]      CHAR (1)   NULL,
    [ic_filtro_tipo_pedido]     CHAR (1)   NULL,
    [ic_tipo_conversao_moeda]   CHAR (1)   NULL,
    CONSTRAINT [PK_Parametro_BI] PRIMARY KEY CLUSTERED ([cd_empresa] ASC, [cd_usuario] ASC, [dt_usuario] ASC) WITH (FILLFACTOR = 90)
);

