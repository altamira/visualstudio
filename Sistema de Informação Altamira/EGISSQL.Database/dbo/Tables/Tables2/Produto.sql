CREATE TABLE [dbo].[Produto] (
    [cd_produto]                   INT           NOT NULL,
    [cd_mascara_produto]           VARCHAR (20)  NULL,
    [nm_produto]                   VARCHAR (50)  NULL,
    [nm_fantasia_produto]          VARCHAR (30)  NULL,
    [nm_marca_produto]             VARCHAR (30)  NULL,
    [qt_peso_liquido]              FLOAT (53)    NULL,
    [qt_peso_bruto]                FLOAT (53)    NULL,
    [ds_produto]                   TEXT          NULL,
    [qt_espessura_produto]         FLOAT (53)    NULL,
    [qt_largura_produto]           FLOAT (53)    NULL,
    [qt_comprimento_produto]       FLOAT (53)    NULL,
    [qt_altura_produto]            FLOAT (53)    NULL,
    [cd_grupo_produto]             INT           NULL,
    [cd_status_produto]            INT           NULL,
    [cd_unidade_medida]            INT           NULL,
    [cd_tipo_embalagem]            INT           NULL,
    [cd_origem_produto]            INT           NULL,
    [cd_agrupamento_produto]       INT           NULL,
    [cd_categoria_produto]         INT           NULL,
    [qt_dias_entrega_medio]        FLOAT (53)    NULL,
    [vl_produto]                   FLOAT (53)    NULL,
    [vl_fator_conversao_produt]    FLOAT (53)    NULL,
    [cd_produto_baixa_estoque]     INT           NULL,
    [pc_desconto_max_produto]      FLOAT (53)    NULL,
    [pc_desconto_min_produto]      FLOAT (53)    NULL,
    [pc_acrescimo_max_produto]     FLOAT (53)    NULL,
    [pc_acrescimo_min_produto]     FLOAT (53)    NULL,
    [nm_observacao_produto]        VARCHAR (100) NULL,
    [cd_serie_produto]             INT           NULL,
    [cd_usuario]                   INT           NULL,
    [dt_usuario]                   DATETIME      NULL,
    [ic_kogo_produto]              CHAR (1)      NULL,
    [cd_tipo_valoracao]            INT           NULL,
    [nm_complemento_produto]       VARCHAR (50)  NULL,
    [cd_grupo_categoria]           INT           NULL,
    [ic_bem_ind_acessorio_prod]    CHAR (1)      NULL,
    [cd_substituto_produto]        INT           NULL,
    [ic_wapnet_produto]            CHAR (1)      NULL,
    [qt_dia_entrega_medio]         FLOAT (53)    NULL,
    [ic_lote_produto]              CHAR (1)      NULL,
    [cd_termo_garantia]            INT           NULL,
    [ic_Rasteabilidade_produto]    CHAR (1)      NULL,
    [nm_serie_produto]             VARCHAR (30)  NULL,
    [qt_dia_garantia_produto]      INT           NULL,
    [ic_garantia_produto]          CHAR (1)      NULL,
    [ic_rastreabilidade_prod]      CHAR (1)      NULL,
    [cd_substituido_produto]       INT           NULL,
    [cd_un_compra_produto]         INT           NULL,
    [qt_conv_compra_produto]       FLOAT (53)    NULL,
    [cd_un_estoque_produto]        INT           NULL,
    [qt_convestoque_produto]       FLOAT (53)    NULL,
    [ic_controle_pcp_produto]      CHAR (1)      NULL,
    [cd_codigo_barra_produto]      VARCHAR (70)  NULL,
    [ic_desenvolvimento_prod]      CHAR (1)      NULL,
    [ic_descritivo_nf_produto]     CHAR (1)      NULL,
    [nm_produto_complemento]       VARCHAR (50)  NULL,
    [pc_comissao_produto]          FLOAT (53)    NULL,
    [cd_versao_produto]            INT           NULL,
    [qt_leadtime_produto]          INT           NULL,
    [qt_leadtime_compra]           INT           NULL,
    [ic_sob_encomenda_produto]     CHAR (1)      NULL,
    [dt_cadastro_produto]          DATETIME      NULL,
    [cd_moeda]                     INT           NULL,
    [qt_volume_produto]            FLOAT (53)    NULL,
    [cd_plano_financeiro]          INT           NULL,
    [cd_plano_compra]              INT           NULL,
    [ic_baixa_composicao_prod]     CHAR (1)      NULL,
    [ic_dev_composicao_prod]       CHAR (1)      NULL,
    [ic_inspecao_produto]          CHAR (1)      NULL,
    [ic_estoque_inspecao_prod]     CHAR (1)      NULL,
    [cd_laudo_produto]             INT           NULL,
    [ic_comercial_produto]         CHAR (1)      NULL,
    [ic_compra_produto]            CHAR (1)      NULL,
    [ic_producao_produto]          CHAR (1)      NULL,
    [ic_importacao_produto]        CHAR (1)      NULL,
    [ic_exportacao_produto]        CHAR (1)      NULL,
    [ic_beneficiamento_produto]    CHAR (1)      NULL,
    [ic_amostra_produto]           CHAR (1)      NULL,
    [ic_consignacao_produto]       CHAR (1)      NULL,
    [ic_transferencia_produto]     CHAR (1)      NULL,
    [cd_tipo_mercado]              INT           NULL,
    [qt_evolucao_produto]          FLOAT (53)    NULL,
    [ic_guia_trafego_produto]      CHAR (1)      NULL,
    [ic_pol_federal_produto]       CHAR (1)      NULL,
    [ic_exercito_produto]          CHAR (1)      NULL,
    [qt_concentracao_produto]      FLOAT (53)    NULL,
    [qt_densidade_produto]         FLOAT (53)    NULL,
    [ic_revenda_produto]           CHAR (1)      NULL,
    [ic_tecnica_produto]           CHAR (1)      NULL,
    [ic_almox_produto]             CHAR (1)      NULL,
    [cd_cor]                       INT           NULL,
    [cd_exercito_produto]          VARCHAR (20)  NULL,
    [nm_exercito_produto]          VARCHAR (50)  NULL,
    [cd_policia_federal]           VARCHAR (20)  NULL,
    [nm_policia_federal]           VARCHAR (50)  NULL,
    [cd_policia_civil]             VARCHAR (20)  NULL,
    [nm_policia_civil]             VARCHAR (50)  NULL,
    [ic_usar_valor_composicao]     CHAR (1)      NULL,
    [cd_preco_frete]               INT           NULL,
    [cd_preco_montagem_produto]    INT           NULL,
    [cd_fase_produto_baixa]        INT           NULL,
    [ic_processo_produto]          CHAR (1)      NULL,
    [vl_anterior_produto]          FLOAT (53)    NULL,
    [cd_periculosidade]            INT           NULL,
    [dt_exportacao_registro]       DATETIME      NULL,
    [ic_mapa_exercito]             CHAR (1)      NULL,
    [ic_mapa_pol_civil]            CHAR (1)      NULL,
    [dt_alteracao_produto]         DATETIME      NULL,
    [cd_materia_prima]             INT           NULL,
    [cd_propaganda]                INT           NULL,
    [vl_produto_mercado]           FLOAT (53)    NULL,
    [qt_limite_venda_mes]          FLOAT (53)    NULL,
    [ic_controlado_exportacao]     CHAR (1)      NULL,
    [ic_fmea_produto]              CHAR (1)      NULL,
    [ic_plano_controle_produto]    CHAR (1)      NULL,
    [ic_emergencia_produto]        CHAR (1)      NULL,
    [ic_promocao_produto]          CHAR (1)      NULL,
    [qt_multiplo_embalagem]        FLOAT (53)    NULL,
    [cd_tabela_preco]              INT           NULL,
    [cd_tipo_retalho]              INT           NULL,
    [cd_prazo]                     INT           NULL,
    [nm_preco_lista_produto]       VARCHAR (40)  NULL,
    [cd_local_entrega_mov_caixa]   INT           NULL,
    [ic_dadotec_produto]           CHAR (1)      NULL,
    [ic_pcp_produto]               CHAR (1)      NULL,
    [ic_especial_produto]          CHAR (1)      NULL,
    [qt_peso_embalagem_produto]    FLOAT (53)    NULL,
    [ic_analise_produto]           CHAR (1)      NULL,
    [ic_numero_serie_produto]      CHAR (1)      NULL,
    [nm_fantasia_produto_novo]     VARCHAR (30)  NULL,
    [ic_entrada_estoque_fat]       CHAR (1)      NULL,
    [pc_icms_produto]              FLOAT (53)    NULL,
    [cd_tributacao]                INT           NULL,
    [ic_estoque_caixa_produto]     CHAR (1)      NULL,
    [ic_lista_preco_caixa_produto] CHAR (1)      NULL,
    [ic_controlar_montagem_pv]     CHAR (1)      NULL,
    [qt_cubagem_produto]           FLOAT (53)    NULL,
    [nm_fantasia_antigo]           VARCHAR (30)  NULL,
    [qt_peso_especifico_produto]   FLOAT (53)    NULL,
    [qt_minimo_venda_produto]      FLOAT (53)    NULL,
    [cd_marca_produto]             INT           NULL,
    [cd_desenho_produto]           VARCHAR (30)  NULL,
    [cd_rev_desenho_produto]       VARCHAR (5)   NULL,
    [qt_area_produto]              FLOAT (53)    NULL,
    [cd_modalidade_dureza]         INT           NULL,
    [cd_tolerancia_produto]        INT           NULL,
    [cd_certificado_produto]       VARCHAR (30)  NULL,
    [cd_tipo_criticidade]          INT           NULL,
    [nm_modelo_produto]            VARCHAR (30)  NULL,
    [cd_modelo_proposta]           INT           NULL,
    [cd_cliente_produto]           INT           NULL,
    [qt_diam_interno_produto]      FLOAT (53)    NULL,
    [qt_diam_externo_produto]      FLOAT (53)    NULL,
    [cd_interface]                 INT           NULL,
    [ic_exporta_produto]           CHAR (1)      NULL,
    [ic_bonificacao_produto]       CHAR (1)      NULL,
    [cd_laudo_padrao]              INT           NULL,
    [cd_sequencial_produto]        INT           NULL,
    [cd_familia_produto]           INT           NULL,
    CONSTRAINT [PK_Produto] PRIMARY KEY CLUSTERED ([cd_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Marca_Produto] FOREIGN KEY ([cd_marca_produto]) REFERENCES [dbo].[Marca_Produto] ([cd_marca_produto]),
    CONSTRAINT [FK_Produto_Tributacao_Cupom_Fiscal] FOREIGN KEY ([cd_tributacao]) REFERENCES [dbo].[Tributacao_Cupom_Fiscal] ([cd_tributacao])
);


GO
CREATE NONCLUSTERED INDEX [XIF20Produto]
    ON [dbo].[Produto]([cd_grupo_produto] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [XIF24Produto]
    ON [dbo].[Produto]([cd_usuario] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [XIF28Produto]
    ON [dbo].[Produto]([cd_unidade_medida] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [ix_nm_fantasia_produto]
    ON [dbo].[Produto]([nm_fantasia_produto] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [ix_grupo_produto]
    ON [dbo].[Produto]([cd_grupo_produto] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [ix_cd_mascara_produto]
    ON [dbo].[Produto]([cd_mascara_produto] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [ix_nm_produto]
    ON [dbo].[Produto]([nm_produto] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [ix_cd_produto_baixa_estoque]
    ON [dbo].[Produto]([cd_produto_baixa_estoque] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Fantasia_Produto]
    ON [dbo].[Produto]([nm_fantasia_produto] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Produto_cd_serie]
    ON [dbo].[Produto]([cd_serie_produto] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Produto_cd_status]
    ON [dbo].[Produto]([cd_status_produto] ASC) WITH (FILLFACTOR = 90);


GO
GRANT DELETE
    ON OBJECT::[dbo].[Produto] TO PUBLIC
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[Produto] TO PUBLIC
    AS [dbo];


GO
GRANT REFERENCES
    ON OBJECT::[dbo].[Produto] TO PUBLIC
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[Produto] TO PUBLIC
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[Produto] TO PUBLIC
    AS [dbo];

