﻿CREATE TABLE [dbo].[Operacao_Fiscal] (
    [cd_operacao_fiscal]          INT          NOT NULL,
    [cd_mascara_operacao]         CHAR (6)     NULL,
    [nm_operacao_fiscal]          VARCHAR (35) NULL,
    [cd_tributacao]               INT          NULL,
    [nm_obs_livro_operacao]       VARCHAR (40) NULL,
    [cd_grupo_operacao_fiscal]    INT          NULL,
    [cd_operacao_fiscal_pai]      INT          NULL,
    [cd_tipo_movimento_estoque]   INT          NULL,
    [ic_comercial_operacao]       CHAR (1)     NULL,
    [ic_credito_icms_operacao]    CHAR (1)     NULL,
    [ic_credito_ipi_operacao]     CHAR (1)     NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    [cd_tipo_calculo]             CHAR (1)     NULL,
    [nm_mensagem_operacao]        TEXT         NULL,
    [qt_baseicms_op_fiscal]       FLOAT (53)   NULL,
    [ic_contribicms_op_fiscal]    CHAR (1)     NULL,
    [ic_equipind_op_fiscal]       CHAR (1)     NULL,
    [ic_soma_arqmag_op_fiscal]    CHAR (1)     NULL,
    [ic_devmp_operacao_fiscal]    CHAR (1)     NULL,
    [ic_outra_operacao_fiscal]    CHAR (1)     NULL,
    [ic_destaca_vlr_livro_op_f]   CHAR (1)     NULL,
    [ic_opinterestadual_op_fis]   CHAR (1)     NULL,
    [ic_peps_operacao_fiscal]     CHAR (1)     NULL,
    [ic_custo_operacao_fiscal]    CHAR (1)     NULL,
    [ic_estoque_op_fiscal]        CHAR (1)     NULL,
    [ic_terceiro_op_fiscal]       CHAR (1)     NULL,
    [ic_zfm_operacao_fiscal]      CHAR (1)     NULL,
    [qt_prazo_operacao_fiscal]    INT          NULL,
    [ic_retorno_op_fiscal]        CHAR (1)     NULL,
    [cd_tipo_destinatario]        INT          NULL,
    [ic_desconto_especial]        CHAR (1)     NULL,
    [cd_tipo_natureza_operacao]   INT          NULL,
    [cd_oper_fiscal_entrada]      INT          NULL,
    [cd_destinacao_produto]       INT          NULL,
    [cd_plano_financeiro]         INT          NULL,
    [ic_liberadig_op_fiscal]      CHAR (1)     NULL,
    [cd_dispositivo_legal_icms]   INT          NULL,
    [cd_dispositivo_legal_ipi]    INT          NULL,
    [cd_fase_produto]             INT          NULL,
    [ic_dipi_operacao_fiscal]     CHAR (1)     NULL,
    [cd_oper_fiscal_sub_trib]     INT          NULL,
    [cd_oper_fiscal_subtrib]      INT          NULL,
    [ic_servico_operacao]         CHAR (1)     NULL,
    [ic_scp_operacao_fiscal]      CHAR (1)     NULL,
    [ic_imp_operacao_fiscal]      CHAR (1)     NULL,
    [ic_iss_operacao_fiscal]      CHAR (1)     NULL,
    [ic_ativo_operacao_fiscal]    CHAR (1)     NULL,
    [ic_ciap_operacao_fiscal]     CHAR (1)     NULL,
    [ic_pis_operacao_fiscal]      CHAR (1)     NULL,
    [ic_cofins_operacao_fiscal]   CHAR (1)     NULL,
    [ic_estoque_reserva_op_fis]   CHAR (1)     NULL,
    [ic_nota_entrada_op_fiscal]   CHAR (1)     NULL,
    [ic_dev_scp_op_fiscal]        CHAR (1)     NULL,
    [cd_fase_saida_op_fiscal]     INT          NULL,
    [cd_fase_entrada_op_fiscal]   INT          NULL,
    [cd_oper_fiscal_smo]          INT          NULL,
    [cd_oper_fiscal_op_triang]    INT          NULL,
    [cd_oper_fiscal_opt_prox]     INT          NULL,
    [cd_oper_fiscal_ncont_icms]   INT          NULL,
    [ic_nota_origem_op_fiscal]    CHAR (1)     NULL,
    [ic_fiscal_nota_op_fiscal]    CHAR (1)     NULL,
    [cd_lancamento_padrao]        INT          NULL,
    [ic_tributacao_op_fiscal]     CHAR (1)     NULL,
    [qt_base_icms_op_fiscal]      FLOAT (53)   NULL,
    [cd_categoria_dipi]           INT          NULL,
    [ic_complemento_op_fiscal]    CHAR (1)     NULL,
    [ic_custo_produto_operacao]   CHAR (1)     NULL,
    [ic_gerar_pedido_compra]      CHAR (1)     NULL,
    [ic_consignacao_op_fiscal]    CHAR (1)     NULL,
    [ic_importacao_op_fiscal]     CHAR (1)     NULL,
    [ic_exportacao_op_fiscal]     CHAR (1)     NULL,
    [ic_cat95_operacao_fiscal]    CHAR (1)     NULL,
    [ic_tipo_consig_op_fiscal]    CHAR (1)     NULL,
    [ic_tipo_terc_op_fiscal]      CHAR (1)     NULL,
    [ic_subst_tributaria]         CHAR (1)     NULL,
    [cd_tipo_pessoa]              INT          NULL,
    [ic_analise_op_fiscal]        CHAR (1)     NULL,
    [cd_normaldevol_mastersaf]    INT          NULL,
    [cd_entradasaida_mastersaf]   INT          NULL,
    [ic_pisconfis_op_fiscal]      CHAR (1)     NULL,
    [ic_req_fat_op_fiscal]        CHAR (1)     NULL,
    [ic_credito_frete_op_fiscal]  CHAR (1)     NULL,
    [ic_procedencia_op_fiscal]    CHAR (1)     NULL,
    [ic_piscofins_op_fiscal]      CHAR (1)     NULL,
    [ic_destinatario_faturamento] CHAR (1)     NULL,
    [cd_oper_fiscal_amostra]      INT          NULL,
    [cd_oper_fiscal_consig]       INT          NULL,
    [cd_oper_entrega_futura]      INT          NULL,
    [ic_entrega_futura]           CHAR (1)     NULL,
    [ic_bloqueia_lote_operacao]   CHAR (1)     NULL,
    [ic_materia_prima_aplicada]   CHAR (1)     NULL,
    [pc_materia_prima_aplicada]   FLOAT (53)   NULL,
    [pc_mao_obra_aplicada]        FLOAT (53)   NULL,
    [ic_nota_saida_op_fiscal]     CHAR (1)     NULL,
    [ic_saldo_op_fiscal]          CHAR (1)     NULL,
    [ic_icms_parcela_operacao]    CHAR (1)     NULL,
    [ic_custo_nota_entrada]       CHAR (1)     NULL,
    [ic_dados_nfe_op_fiscal]      CHAR (1)     NULL,
    [ic_comissao_op_fiscal]       CHAR (1)     NULL,
    [cd_oper_fiscal_bonif]        INT          NULL,
    [ic_carga_op_fiscal]          CHAR (1)     NULL,
    [ic_benef_automatico_pedido]  CHAR (1)     NULL,
    [ic_fase_op_fiscal]           CHAR (1)     NULL,
    [cd_natureza_exportacao]      INT          NULL,
    [ic_ret_piscofins_fiscal]     CHAR (1)     NULL,
    [ic_frete_base_ipi_op_fiscal] CHAR (1)     NULL,
    [cd_finalidade_nfe]           INT          NULL,
    [cd_opf_benef_entrada]        INT          NULL,
    [ic_calculo_piscofins]        CHAR (1)     NULL,
    [ic_cred_presum_op_fiscal]    CHAR (1)     NULL,
    CONSTRAINT [PK_Operacao_Fiscal] PRIMARY KEY CLUSTERED ([cd_operacao_fiscal] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [ix_cd_mascara_operacao]
    ON [dbo].[Operacao_Fiscal]([cd_mascara_operacao] ASC) WITH (FILLFACTOR = 90);

