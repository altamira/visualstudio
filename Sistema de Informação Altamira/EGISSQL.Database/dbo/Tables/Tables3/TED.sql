CREATE TABLE [dbo].[TED] (
    [cd_ted]                 INT          NOT NULL,
    [dt_ted]                 DATETIME     NULL,
    [vl_ted]                 FLOAT (53)   NULL,
    [cd_banco]               INT          NULL,
    [nm_referencia_ted]      VARCHAR (60) NULL,
    [nm_agencia_ted]         VARCHAR (25) NULL,
    [nm_contato_agencia_ted] VARCHAR (30) NULL,
    [nm_obs_ted]             VARCHAR (40) NULL,
    [cd_empresa_diversa]     INT          NULL,
    [cd_favorecido_empresa]  INT          NULL,
    [cd_conta_banco]         INT          NULL,
    [ds_ted]                 TEXT         NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [nm_conta_banco]         VARCHAR (20) NULL,
    CONSTRAINT [PK_TED] PRIMARY KEY CLUSTERED ([cd_ted] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_TED_Banco] FOREIGN KEY ([cd_banco]) REFERENCES [dbo].[Banco] ([cd_banco]),
    CONSTRAINT [FK_TED_Conta_Agencia_Banco] FOREIGN KEY ([cd_conta_banco]) REFERENCES [dbo].[Conta_Agencia_Banco] ([cd_conta_banco]),
    CONSTRAINT [FK_TED_Empresa_Diversa] FOREIGN KEY ([cd_empresa_diversa]) REFERENCES [dbo].[Empresa_Diversa] ([cd_empresa_diversa])
);

