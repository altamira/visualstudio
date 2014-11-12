﻿CREATE TABLE [dbo].[Parametro_Empresa] (
    [cd_empresa]                   INT          NOT NULL,
    [aa_exercicio_empresa]         INT          NULL,
    [cd_nota_fiscal_saida]         INT          NULL,
    [cd_nota_fiscal_entrada]       INT          NULL,
    [cd_nota_fiscal_servico]       INT          NULL,
    [vl_faturamento_minimo]        MONEY        NULL,
    [vl_faturamento_maximo]        MONEY        NULL,
    [ds_cartorio_empresa]          TEXT         NULL,
    [nm_inscricao_municipal]       VARCHAR (18) NULL,
    [cd_contador]                  INT          NULL,
    [cd_usuario_atualiza]          INT          NULL,
    [dt_atualiza]                  DATETIME     NULL,
    [cd_fornecedor_empresa]        INT          NULL,
    [cd_requisicao_compra_empresa] INT          NULL,
    [cd_cotacao_empresa]           INT          NULL,
    [cd_pedido_compra_empresa]     INT          NULL,
    [cd_fmedida_empresa]           INT          NULL,
    [cd_ult_nf_entrada_empresa]    INT          NULL,
    [cd_carta_correcao_empresa]    INT          NULL,
    [cd_rem_empresa]               INT          NULL,
    [cd_rena_empresa]              INT          NULL,
    [cd_cliente_empresa]           INT          NULL,
    [cd_consulta_empresa]          INT          NULL,
    [cd_cocorrencia_empresa]       INT          NULL,
    [cd_pedido_venda]              INT          NULL,
    [cd_processo_fab_empresa]      INT          NULL,
    [cd_ult_nf_saida_empresa]      INT          NULL,
    [cd_req_faturamento_empresa]   INT          NULL,
    [cd_previa_fat_empresa]        INT          NULL,
    [cd_os_assist_tec_empresa]     INT          NULL,
    [cd_lancamento_estoque]        INT          NULL,
    [cd_consulta_assitatura]       INT          NULL,
    [ic_tipo_proposta]             CHAR (1)     NULL,
    [ic_obs_cotacao_empresa]       CHAR (1)     NULL,
    [ds_obs_cotacao_empresa]       VARCHAR (60) NULL,
    [ic_frete_cotacao_empresa]     CHAR (1)     NULL,
    [cd_documento_pagar_diverso]   INT          NULL,
    [vl_liberacao_pedido_compra]   FLOAT (53)   NULL,
    [ic_controla_desconto]         CHAR (1)     NULL,
    [cd_fornecedor]                INT          NULL,
    [cd_req_compra_empresa]        INT          NULL,
    [cd_concorrencia_empresa]      INT          NULL,
    [cd_req_fatura_empresa]        INT          NULL,
    [cd_consulta_assinatura]       INT          NULL,
    [cd_doc_pagar_diverso]         INT          NULL,
    [vl_liberacao_ped_compra]      FLOAT (53)   NULL,
    [cd_usuario]                   INT          NULL,
    [dt_usuario]                   DATETIME     NULL,
    [qt_servico_nota_empresa]      INT          NULL,
    [qt_pagreg_saida_empresa]      INT          NULL,
    [qt_pagreg_entrada]            INT          NULL,
    [cd_exercicio_empresa]         INT          NULL,
    [ic_nao_imprime_acento]        CHAR (1)     NULL,
    CONSTRAINT [PK_Parametro_Empresa] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

