﻿CREATE TABLE [dbo].[Veiculo_Multa] (
    [cd_veiculo_multa]        INT          NOT NULL,
    [dt_veiculo_multa]        DATETIME     NOT NULL,
    [cd_veiculo]              INT          NULL,
    [cd_motorista]            INT          NULL,
    [cd_multa_transito]       INT          NULL,
    [vl_veiculo_multa]        FLOAT (53)   NULL,
    [dt_vencto_veiculo_multa] DATETIME     NULL,
    [nm_local_veiculo_multa]  VARCHAR (60) NULL,
    [nm_obs_veiculo_multa]    VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_notificacao_multa]    VARCHAR (20) NULL,
    [vl_desconto_multa]       FLOAT (53)   NULL,
    [vl_multa]                FLOAT (53)   NULL,
    [hr_multa]                VARCHAR (8)  NULL,
    [ic_pagamento_desconto]   CHAR (1)     NULL,
    [ic_desconto_motorista]   CHAR (1)     NULL,
    [cd_documento_pagar]      INT          NULL,
    [cd_orgao_multa]          INT          NULL,
    [cd_auto_infracao_multa]  VARCHAR (40) NULL,
    [dt_lancamento_multa]     DATETIME     NULL,
    [cd_estado]               INT          NULL,
    [cd_cidade]               INT          NULL,
    [nm_referencia_multa]     VARCHAR (40) NULL,
    [ic_empresa_multa]        CHAR (1)     NULL,
    CONSTRAINT [PK_Veiculo_Multa] PRIMARY KEY CLUSTERED ([cd_veiculo_multa] ASC, [dt_veiculo_multa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Veiculo_Multa_Multa_Transito] FOREIGN KEY ([cd_multa_transito]) REFERENCES [dbo].[Multa_Transito] ([cd_multa_transito]),
    CONSTRAINT [FK_Veiculo_Multa_Orgao_Multa] FOREIGN KEY ([cd_orgao_multa]) REFERENCES [dbo].[Orgao_Multa] ([cd_orgao_multa])
);

