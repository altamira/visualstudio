CREATE TABLE [dbo].[Manutencao] (
    [cd_manutencao]            INT          NULL,
    [cd_contrato_concessao]    INT          NULL,
    [cd_doc_manutencao]        VARCHAR (30) NULL,
    [cd_periodo_manutencao]    CHAR (5)     NULL,
    [dt_vencimento_manutencao] DATETIME     NULL,
    [vl_manutencao]            FLOAT (53)   NULL,
    [dt_pagamento_manutencao]  DATETIME     NULL,
    [vl_pago_manutencao]       FLOAT (53)   NULL,
    [ds_obs_manutencao]        TEXT         NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL
);

