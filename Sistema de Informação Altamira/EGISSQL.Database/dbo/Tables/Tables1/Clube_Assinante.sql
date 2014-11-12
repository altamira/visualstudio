CREATE TABLE [dbo].[Clube_Assinante] (
    [cd_assinante]        INT          NOT NULL,
    [cd_cadastro]         INT          NOT NULL,
    [cd_tipo_plano]       INT          NOT NULL,
    [dt_assinante]        DATETIME     NULL,
    [dt_vencimento]       DATETIME     NULL,
    [cd_tipo_pagamento]   INT          NULL,
    [cd_cartao_credito]   INT          NULL,
    [cd_numero_cartao]    VARCHAR (16) NULL,
    [cd_numero_seguranca] VARCHAR (5)  NULL,
    [dt_validade_cartao]  VARCHAR (8)  NULL,
    [dt_nascimento]       DATETIME     NULL,
    [nm_obs_assinante]    VARCHAR (40) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Clube_Assinante] PRIMARY KEY CLUSTERED ([cd_assinante] ASC),
    CONSTRAINT [FK_Clube_Assinante_Tipo_Cartao_Credito] FOREIGN KEY ([cd_cartao_credito]) REFERENCES [dbo].[Tipo_cartao_credito] ([cd_cartao_credito])
);

