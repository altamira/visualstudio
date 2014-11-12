CREATE TABLE [dbo].[Ferias] (
    [cd_ferias]            INT          NOT NULL,
    [dt_ferias]            DATETIME     NULL,
    [cd_funcionario]       INT          NOT NULL,
    [dt_inicio_a_ferias]   DATETIME     NULL,
    [dt_fim_a_ferias]      DATETIME     NULL,
    [dt_inicio_g_ferias]   DATETIME     NULL,
    [dt_fim_g_ferias]      DATETIME     NULL,
    [qt_falta_funcionario] INT          NULL,
    [ic_parcela_13_ferias] CHAR (1)     NULL,
    [dt_aviso_ferias]      DATETIME     NULL,
    [dt_pagamento_ferias]  DATETIME     NULL,
    [nm_obs_ferias]        VARCHAR (60) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [qt_dia_ferias]        INT          NULL,
    [dt_vencimento_ferias] DATETIME     NULL,
    CONSTRAINT [PK_Ferias] PRIMARY KEY CLUSTERED ([cd_ferias] ASC, [cd_funcionario] ASC),
    CONSTRAINT [FK_Ferias_Funcionario] FOREIGN KEY ([cd_funcionario]) REFERENCES [dbo].[Funcionario] ([cd_funcionario])
);

