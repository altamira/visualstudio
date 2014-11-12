﻿CREATE TABLE [dbo].[Pedido_Venda] (
    [cd_pedido_venda]               INT          NOT NULL,
    [dt_pedido_venda]               DATETIME     NULL,
    [cd_vendedor_pedido]            INT          NULL,
    [cd_vendedor_interno]           INT          NULL,
    [ic_emitido_pedido_venda]       CHAR (1)     NULL,
    [ds_pedido_venda]               TEXT         NULL,
    [ds_pedido_venda_fatura]        TEXT         NULL,
    [ds_cancelamento_pedido]        VARCHAR (60) NULL,
    [cd_usuario_credito_pedido]     INT          NULL,
    [dt_credito_pedido_venda]       DATETIME     NULL,
    [ic_smo_pedido_venda]           CHAR (1)     NULL,
    [vl_total_pedido_venda]         FLOAT (53)   NULL,
    [qt_liquido_pedido_venda]       FLOAT (53)   NULL,
    [qt_bruto_pedido_venda]         FLOAT (53)   NULL,
    [dt_conferido_pedido_venda]     DATETIME     NULL,
    [ic_pcp_pedido_venda]           CHAR (1)     NULL,
    [ic_lista_pcp_pedido_venda]     CHAR (1)     NULL,
    [ic_processo_pedido_venda]      CHAR (1)     NULL,
    [ic_lista_processo_pedido]      CHAR (1)     NULL,
    [ic_imed_pedido_venda]          CHAR (1)     NULL,
    [ic_lista_imed_pedido]          CHAR (1)     NULL,
    [nm_alteracao_pedido_venda]     VARCHAR (60) NULL,
    [ic_consignacao_pedido]         CHAR (1)     NULL,
    [dt_cambio_pedido_venda]        DATETIME     NULL,
    [cd_cliente_entrega]            INT          NULL,
    [ic_op_triang_pedido_venda]     CHAR (1)     NULL,
    [ic_nf_op_triang_pedido]        CHAR (1)     NULL,
    [nm_contato_op_triang]          VARCHAR (30) NULL,
    [cd_pdcompra_pedido_venda]      VARCHAR (40) NULL,
    [cd_processo_exportacao]        INT          NULL,
    [cd_cliente]                    INT          NULL,
    [cd_tipo_frete]                 INT          NULL,
    [cd_tipo_restricao_pedido]      INT          NULL,
    [cd_destinacao_produto]         INT          NULL,
    [cd_tipo_pedido]                INT          NULL,
    [cd_transportadora]             INT          NULL,
    [cd_vendedor]                   INT          NULL,
    [cd_tipo_endereco]              INT          NULL,
    [cd_moeda]                      INT          NULL,
    [cd_contato]                    INT          NULL,
    [cd_usuario]                    INT          NULL,
    [dt_usuario]                    DATETIME     NULL,
    [dt_cancelamento_pedido]        DATETIME     NULL,
    [cd_condicao_pagamento]         INT          NULL,
    [cd_status_pedido]              INT          NULL,
    [cd_tipo_entrega_produto]       INT          NULL,
    [nm_referencia_consulta]        VARCHAR (40) NULL,
    [vl_custo_financeiro]           FLOAT (53)   NULL,
    [ic_custo_financeiro]           CHAR (1)     NULL,
    [vl_tx_mensal_cust_fin]         FLOAT (53)   NULL,
    [cd_tipo_pagamento_frete]       INT          NULL,
    [nm_assina_pedido]              VARCHAR (50) NULL,
    [ic_fax_pedido]                 CHAR (1)     NULL,
    [ic_mail_pedido]                CHAR (1)     NULL,
    [vl_total_pedido_ipi]           FLOAT (53)   NULL,
    [vl_total_ipi]                  FLOAT (53)   NULL,
    [ds_observacao_pedido]          TEXT         NULL,
    [cd_usuario_atendente]          INT          NULL,
    [ic_fechado_pedido]             CHAR (1)     NULL,
    [ic_vendedor_interno]           CHAR (1)     NULL,
    [cd_representante]              INT          NULL,
    [ic_transf_matriz]              CHAR (1)     NULL,
    [ic_digitacao]                  CHAR (1)     NULL,
    [ic_pedido_venda]               CHAR (1)     NULL,
    [hr_inicial_pedido]             DATETIME     NULL,
    [ic_outro_cliente]              CHAR (1)     NULL,
    [ic_fechamento_total]           CHAR (1)     NULL,
    [ic_operacao_triangular]        CHAR (1)     NULL,
    [ic_fatsmo_pedido]              CHAR (1)     NULL,
    [ds_ativacao_pedido]            VARCHAR (60) NULL,
    [dt_ativacao_pedido]            DATETIME     NULL,
    [ds_obs_fat_pedido]             TEXT         NULL,
    [ic_obs_corpo_nf]               CHAR (1)     NULL,
    [dt_fechamento_pedido]          DATETIME     NULL,
    [cd_cliente_faturar]            INT          NULL,
    [cd_tipo_local_entrega]         INT          NULL,
    [ic_etiq_emb_pedido_venda]      CHAR (1)     NULL,
    [cd_consulta]                   INT          NULL,
    [dt_alteracao_pedido_venda]     DATETIME     NULL,
    [ic_dt_especifica_ped_vend]     DATETIME     NULL,
    [ic_dt_especifica_consulta]     DATETIME     NULL,
    [ic_fat_pedido_venda]           CHAR (1)     NULL,
    [ic_fat_total_pedido_venda]     CHAR (1)     NULL,
    [qt_volume_pedido_venda]        INT          NULL,
    [qt_fatpbru_pedido_venda]       FLOAT (53)   NULL,
    [ic_permite_agrupar_pedido]     CHAR (1)     NULL,
    [qt_fatpliq_pedido_venda]       FLOAT (53)   NULL,
    [vl_indice_pedido_venda]        FLOAT (53)   NULL,
    [vl_sedex_pedido_venda]         FLOAT (53)   NULL,
    [pc_desconto_pedido_venda]      FLOAT (53)   NULL,
    [pc_comissao_pedido_venda]      FLOAT (53)   NULL,
    [cd_plano_financeiro]           INT          NULL,
    [ds_multa_pedido_venda]         TEXT         NULL,
    [vl_freq_multa_ped_venda]       INT          NULL,
    [vl_base_multa_ped_venda]       FLOAT (53)   NULL,
    [pc_limite_multa_ped_venda]     FLOAT (53)   NULL,
    [pc_multa_pedido_venda]         FLOAT (53)   NULL,
    [cd_fase_produto_contrato]      INT          NULL,
    [nm_obs_restricao_pedido]       VARCHAR (40) NULL,
    [cd_usu_restricao_pedido]       INT          NULL,
    [dt_lib_restricao_pedido]       DATETIME     NULL,
    [nm_contato_op_triang_ped]      VARCHAR (30) NULL,
    [ic_amostra_pedido_venda]       CHAR (1)     CONSTRAINT [DF_Pedido_Venda_ic_amostra_pedido_venda] DEFAULT ('N') NULL,
    [ic_alteracao_pedido_venda]     CHAR (1)     CONSTRAINT [DF_Pedido_Venda_ic_alteracao_pedido_venda] DEFAULT ('N') NULL,
    [ic_calcula_sedex]              CHAR (1)     NULL,
    [vl_frete_pedido_venda]         FLOAT (53)   NULL,
    [ic_calcula_peso]               CHAR (1)     NULL,
    [ic_subs_trib_pedido_venda]     CHAR (1)     NULL,
    [ic_credito_icms_pedido]        CHAR (1)     NULL,
    [cd_usu_lib_fat_min_pedido]     INT          NULL,
    [dt_lib_fat_min_pedido]         DATETIME     NULL,
    [cd_identificacao_empresa]      VARCHAR (15) NULL,
    [pc_comissao_especifico]        FLOAT (53)   NULL,
    [dt_ativacao_pedido_venda]      DATETIME     NULL,
    [cd_exportador]                 INT          NULL,
    [ic_atualizar_valor_cambio_fat] CHAR (1)     NULL,
    [cd_tipo_documento]             INT          NULL,
    [cd_loja]                       INT          NULL,
    [cd_usuario_alteracao]          INT          NULL,
    [ic_garantia_pedido_venda]      CHAR (1)     NULL,
    [cd_aplicacao_produto]          INT          NULL,
    [ic_comissao_pedido_venda]      CHAR (1)     NULL,
    [cd_motivo_liberacao]           INT          NULL,
    [ic_entrega_futura]             CHAR (1)     NULL,
    [modalidade]                    MONEY        NULL,
    [modalidade1]                   VARCHAR (60) NULL,
    [cd_modalidade]                 INT          NULL,
    [cd_pedido_venda_origem]        INT          NULL,
    [dt_entrada_pedido]             DATETIME     NULL,
    [dt_cond_pagto_pedido]          DATETIME     NULL,
    [cd_usuario_cond_pagto_ped]     INT          NULL,
    [vl_credito_liberacao]          FLOAT (53)   NULL,
    [vl_credito_liberado]           FLOAT (53)   NULL,
    [cd_centro_custo]               INT          NULL,
    [ic_bloqueio_licenca]           CHAR (1)     NULL,
    [cd_licenca_bloqueada]          INT          NULL,
    [nm_bloqueio_licenca]           VARCHAR (50) NULL,
    [dt_bloqueio_licenca]           DATETIME     NULL,
    [cd_usuario_bloqueio_licenca]   INT          NULL,
    [vl_mp_aplicacada_pedido]       FLOAT (53)   NULL,
    [vl_mo_aplicada_pedido]         FLOAT (53)   NULL,
    [cd_usuario_impressao]          INT          NULL,
    [cd_cliente_origem]             INT          NULL,
    [cd_situacao_pedido]            INT          NULL,
    [qt_total_item_pedido]          FLOAT (53)   NULL,
    [ic_bonificacao_pedido_venda]   CHAR (1)     NULL,
    [pc_promocional_pedido]         FLOAT (53)   NULL,
    [cd_tipo_reajuste]              INT          NULL,
    [vl_icms_st]                    FLOAT (53)   NULL,
    CONSTRAINT [PK_Pedido_Venda] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Pedido_Venda_Exportador] FOREIGN KEY ([cd_exportador]) REFERENCES [dbo].[Exportador] ([cd_exportador])
);


GO
CREATE NONCLUSTERED INDEX [ix_dt_pedido_venda]
    ON [dbo].[Pedido_Venda]([dt_pedido_venda] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [ix_dt_cancelamento_pedido]
    ON [dbo].[Pedido_Venda]([dt_cancelamento_pedido] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Pedido_Venda_Origem]
    ON [dbo].[Pedido_Venda]([cd_pedido_venda_origem] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Pedido_Venda_Pedido_Compra]
    ON [dbo].[Pedido_Venda]([cd_pdcompra_pedido_venda] ASC) WITH (FILLFACTOR = 90);

