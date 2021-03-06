﻿CREATE TABLE [dbo].[Aplicacao_Financeira] (
    [cd_aplicacao_financeira] INT          NOT NULL,
    [dt_aplicacao_financeira] DATETIME     NULL,
    [cd_banco]                INT          NULL,
    [cd_conta_banco]          INT          NULL,
    [cd_tipo_aplicacao_finan] INT          NULL,
    [vl_aplicacao_financeira] MONEY        NULL,
    [vl_rendimento_aplicacao] MONEY        NULL,
    [vl_resgate_aplicacao]    MONEY        NULL,
    [vl_atual_aplicacao]      MONEY        NULL,
    [nm_aplicacao_financeira] VARCHAR (40) NULL,
    [ds_aplicacao_financeira] TEXT         NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [pc_irrf_aplicacao]       FLOAT (53)   NULL,
    [pc_iof_aplicacao]        FLOAT (53)   NULL,
    [cd_plano_financeiro]     INT          NULL,
    [ic_liquidacao_aplicacao] CHAR (1)     NULL,
    [cd_conta]                INT          NULL,
    [cd_lancamento_padrao]    INT          NULL,
    CONSTRAINT [PK_Aplicacao_Financeira] PRIMARY KEY CLUSTERED ([cd_aplicacao_financeira] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Banco] FOREIGN KEY ([cd_banco]) REFERENCES [dbo].[Banco] ([cd_banco]),
    CONSTRAINT [FK_Conta_Agencia_Banco] FOREIGN KEY ([cd_conta_banco]) REFERENCES [dbo].[Conta_Agencia_Banco] ([cd_conta_banco]),
    CONSTRAINT [FK_Tipo_Aplicacao_Financeira] FOREIGN KEY ([cd_tipo_aplicacao_finan]) REFERENCES [dbo].[Tipo_Aplicacao_Financeira] ([cd_tipo_aplicacao_finan])
);

