﻿CREATE TABLE [dbo].[Empresa_Proposta] (
    [cd_proposta_empresa]      INT          NOT NULL,
    [ic_confirmacao_empresa]   CHAR (1)     NULL,
    [ic_cond_fornecimento]     CHAR (1)     NULL,
    [ic_propaganda_empresa]    CHAR (1)     NULL,
    [ic_iso_empresa]           CHAR (1)     NULL,
    [ic_frete_empresa]         CHAR (1)     NULL,
    [ds_mensagem_sup_empresa]  TEXT         NULL,
    [ds_mensagem_inf_empresa]  TEXT         NULL,
    [ic_site_empresa]          CHAR (1)     NULL,
    [ic_endereco_empresa]      CHAR (1)     NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [ic_garantia_proposta]     CHAR (1)     NULL,
    [ic_desc_tecnica_proposta] CHAR (1)     NULL,
    [ic_ie_empresa]            CHAR (1)     NULL,
    [ic_cnpj_empresa]          CHAR (1)     NULL,
    [cd_empresa]               INT          NOT NULL,
    [cd_empresa_assinatura]    INT          NULL,
    [ic_logotipo_empresa]      CHAR (1)     NULL,
    [ic_proposta_empresa]      CHAR (1)     NULL,
    [ic_obs_item_proposta]     CHAR (1)     NULL,
    [NM_TITULO_PROPOSTA]       VARCHAR (60) NULL,
    [IC_MSG_CUSTO_FINANCEIRO]  CHAR (1)     NULL,
    [ic_enviar_anexo_proposta] CHAR (1)     NULL,
    [ic_tipo_anexo_proposta]   CHAR (1)     NULL,
    [ic_desconto_itens]        CHAR (1)     NULL,
    [cd_telefone_empresa]      VARCHAR (15) NULL,
    [cd_fax_empresa]           VARCHAR (20) NULL,
    [ic_exportacao_empresa]    CHAR (1)     NULL,
    CONSTRAINT [PK_Empresa_Proposta] PRIMARY KEY CLUSTERED ([cd_proposta_empresa] ASC, [cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

