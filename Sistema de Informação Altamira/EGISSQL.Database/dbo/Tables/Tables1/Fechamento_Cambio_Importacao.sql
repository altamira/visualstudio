CREATE TABLE [dbo].[Fechamento_Cambio_Importacao] (
    [cd_fechamento_cambio]    INT          NOT NULL,
    [cd_fornecedor]           INT          NULL,
    [nm_contrato_cambio]      VARCHAR (20) NULL,
    [cd_moeda]                INT          NULL,
    [dt_fechamento_cambio]    DATETIME     NULL,
    [vl_moeda]                FLOAT (53)   NULL,
    [vl_tarifa_contrato]      FLOAT (53)   NULL,
    [cd_corretora_cambio]     INT          NULL,
    [nm_obs_fechamento]       VARCHAR (60) NULL,
    [cd_banco]                INT          NULL,
    [cd_agencia_banco]        INT          NULL,
    [cd_conta_banco]          INT          NULL,
    [vl_fechamento_moeda_int] FLOAT (53)   NULL,
    [vl_fechamento_moeda_nac] FLOAT (53)   NULL,
    [qt_documento_fechamento] INT          NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Fechamento_Cambio_Importacao] PRIMARY KEY CLUSTERED ([cd_fechamento_cambio] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Fechamento_Cambio_Importacao_Conta_Agencia_Banco] FOREIGN KEY ([cd_conta_banco]) REFERENCES [dbo].[Conta_Agencia_Banco] ([cd_conta_banco])
);

