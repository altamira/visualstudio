﻿CREATE TABLE [dbo].[Pedido_Compra] (
    [cd_pedido_compra]           INT          NOT NULL,
    [dt_pedido_compra]           DATETIME     NULL,
    [cd_fornecedor]              INT          NULL,
    [cd_contato_fornecedor]      INT          NULL,
    [cd_comprador]               INT          NULL,
    [cd_transportadora]          INT          NULL,
    [ic_pedido_compra]           CHAR (1)     NULL,
    [ds_pedido_compra]           TEXT         NULL,
    [cd_destinacao_produto]      INT          NULL,
    [cd_tipo_pedido]             INT          NULL,
    [cd_tipo_endereco]           INT          NULL,
    [cd_moeda]                   INT          NULL,
    [dt_cambio_pedido_compra]    DATETIME     NULL,
    [cd_condicao_pagamento]      INT          NULL,
    [cd_status_pedido]           INT          NULL,
    [nm_ref_pedido_compra]       VARCHAR (40) NULL,
    [qt_pesoliq_pedido_compra]   FLOAT (53)   NULL,
    [qt_pesobruto_pedido_compra] FLOAT (53)   NULL,
    [vl_total_pedido_compra]     FLOAT (53)   NULL,
    [dt_cancel_ped_compra]       DATETIME     NULL,
    [ds_cancel_ped_compra]       VARCHAR (60) NULL,
    [dt_ativacao_pedido_compra]  DATETIME     NULL,
    [ds_ativacao_pedido_compra]  VARCHAR (60) NULL,
    [dt_nec_pedido_compra]       DATETIME     NULL,
    [dt_conf_pedido_compra]      DATETIME     NULL,
    [dt_alteracao_ped_compra]    DATETIME     NULL,
    [ds_alteracao_ped_compra]    VARCHAR (40) NULL,
    [nm_contato_conf_ped_comp]   VARCHAR (40) NULL,
    [cd_plano_compra]            INT          NULL,
    [cd_centro_custo]            INT          NULL,
    [ic_fax_pedido_compra]       CHAR (1)     NULL,
    [ic_email_pedido_compra]     CHAR (1)     NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [cd_tipo_entrega_produto]    INT          NULL,
    [nm_pedfornec_pedido_compr]  VARCHAR (40) NULL,
    [qt_pesbruto_pedido_compra]  FLOAT (53)   NULL,
    [ic_maquina]                 CHAR (1)     NULL,
    [vl_indice_pedido_compra]    FLOAT (53)   NULL,
    [vl_total_ipi_pedido]        FLOAT (53)   NULL,
    [vl_frete_pedido_compra]     FLOAT (53)   NULL,
    [ic_fechado_pedido_compra]   CHAR (1)     NULL,
    [vl_total_pedido_ipi]        FLOAT (53)   NULL,
    [cd_tipo_local_entrega]      INT          NULL,
    [cd_aplicacao_produto]       INT          NULL,
    [qt_pesobruto_pedido_compr]  FLOAT (53)   NULL,
    [cd_plano_financeiro]        INT          NULL,
    [cd_fase_produto_contrato]   INT          NULL,
    [dt_vcto_pedido_compra]      DATETIME     NULL,
    [cd_tipo_comunicacao]        INT          NULL,
    [nm_conf_pedido_compra]      VARCHAR (60) NULL,
    [cd_departamento]            INT          NULL,
    [cd_requisicao_compra]       INT          NULL,
    [cd_local_entrega_empresa]   INT          NULL,
    [ic_aprov_comprador_pedido]  CHAR (1)     NULL,
    [ic_consignacao_pedido]      CHAR (1)     NULL,
    [pc_frete_pedido_compra]     FLOAT (53)   NULL,
    [pc_custofin_pedido_compra]  FLOAT (53)   NULL,
    [ic_aprov_pedido_compra]     CHAR (1)     NULL,
    [cd_tipo_produto_espessura]  INT          NULL,
    [cd_tipo_alteracao_pedido]   INT          NULL,
    [cd_tipo_envio]              INT          NULL,
    [ic_pedido_gerado_autom]     CHAR (1)     NULL,
    [vl_desconto_pedido_compra]  FLOAT (53)   NULL,
    [cd_destino_compra]          INT          NULL,
    [cd_opcao_compra]            INT          NULL,
    [cd_loja]                    INT          NULL,
    [cd_tipo_pagamento_frete]    INT          NULL,
    [vl_total_pedido_icms]       FLOAT (53)   NULL,
    [cd_motorista]               INT          NULL,
    [vl_icms_st]                 FLOAT (53)   NULL,
    CONSTRAINT [PK_Pedido_Compra] PRIMARY KEY CLUSTERED ([cd_pedido_compra] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [ix_dt_pedido_compra]
    ON [dbo].[Pedido_Compra]([dt_pedido_compra] ASC) WITH (FILLFACTOR = 90);

