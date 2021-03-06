﻿CREATE TABLE [dbo].[Operacao_Cambio] (
    [cd_operacao_cambio]      INT          NOT NULL,
    [cd_ref_operacao_cambio]  VARCHAR (15) NOT NULL,
    [dt_operacao_cambio]      DATETIME     NULL,
    [cd_tipo_operacao_cambio] INT          NULL,
    [cd_contrato_cambio]      INT          NULL,
    [cd_pedido_importacao]    INT          NULL,
    [cd_pedido_venda]         INT          NULL,
    [cd_embarque]             INT          NULL,
    [dt_vencimento_cambio]    DATETIME     NULL,
    [dt_vencto_documento]     DATETIME     NULL,
    [dt_entrega_documento]    DATETIME     NULL,
    [dt_pagamento_cambio]     DATETIME     NULL,
    [dt_liquidacao_cambio]    DATETIME     NULL,
    [pc_operacao_cambio]      FLOAT (53)   NULL,
    [cd_banco]                INT          NULL,
    [cd_agencia_banco]        INT          NULL,
    [cd_motivo_prorrogacao]   INT          NULL,
    [nm_obs_operacao_cambio]  VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Operacao_Cambio] PRIMARY KEY CLUSTERED ([cd_operacao_cambio] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Operacao_Cambio_Motivo_Prorrogacao] FOREIGN KEY ([cd_motivo_prorrogacao]) REFERENCES [dbo].[Motivo_Prorrogacao] ([cd_motivo_prorrogacao])
);

