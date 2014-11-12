CREATE TABLE [dbo].[Movimento_Caixa_Parcela] (
    [cd_movimento_caixa]      INT          NOT NULL,
    [cd_contador_pedido]      INT          NOT NULL,
    [cd_parcela_caixa]        INT          NOT NULL,
    [dt_vencto_parcela_caixa] DATETIME     NULL,
    [vl_parcela_caixa]        MONEY        NULL,
    [cd_banco]                INT          NULL,
    [nm_agencia_banco_caixa]  VARCHAR (40) NULL,
    [nm_obs_parcela_caixa]    VARCHAR (40) NULL,
    [cd_tipo_pagamento]       INT          NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_conta_banco]          VARCHAR (15) NULL,
    [cd_cheque_banco]         VARCHAR (15) NULL,
    [cd_cartao_credito]       VARCHAR (30) NULL,
    [ic_baixa_autom_scr]      CHAR (1)     NULL,
    CONSTRAINT [PK_Movimento_Caixa_Parcela] PRIMARY KEY CLUSTERED ([cd_movimento_caixa] ASC, [cd_contador_pedido] ASC, [cd_parcela_caixa] ASC) WITH (FILLFACTOR = 90)
);

