CREATE TABLE [dbo].[Pedido_Venda_Parcela] (
    [cd_pedido_venda]           INT          NOT NULL,
    [cd_parcela_ped_venda]      INT          NOT NULL,
    [dt_vcto_parcela_ped_venda] DATETIME     NULL,
    [vl_parcela_ped_venda]      FLOAT (53)   NULL,
    [nm_obs_parcela_ped_venda]  VARCHAR (30) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_dt_especifica_ped_vend] CHAR (1)     NULL,
    [cd_ident_parc_ped_venda]   VARCHAR (25) NULL,
    [ic_editado_parc_ped_venda] CHAR (1)     NULL,
    [cd_mes]                    INT          NULL,
    [cd_ano]                    INT          NULL,
    [cd_banco]                  INT          NULL,
    [nm_agencia_banco_caixa]    VARCHAR (40) NULL,
    [nm_obs_parcela_caixa]      VARCHAR (40) NULL,
    [cd_tipo_pagamento]         INT          NULL,
    [cd_conta_banco]            VARCHAR (15) NULL,
    [cd_cheque_banco]           VARCHAR (15) NULL,
    [cd_cartao_credito]         VARCHAR (30) NULL,
    [cd_tipo_documento]         INT          NULL,
    CONSTRAINT [PK_Pedido_Venda_Parcela] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC, [cd_parcela_ped_venda] ASC) WITH (FILLFACTOR = 90)
);

