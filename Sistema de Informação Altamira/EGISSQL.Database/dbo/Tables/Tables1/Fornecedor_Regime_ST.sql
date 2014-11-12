CREATE TABLE [dbo].[Fornecedor_Regime_ST] (
    [cd_fornecedor]            INT          NOT NULL,
    [cd_classificacao_fiscal]  INT          NOT NULL,
    [cd_estado]                INT          NOT NULL,
    [pc_icms_strib_fornecedor] FLOAT (53)   NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [nm_obs_fornecedor_regime] VARCHAR (40) NULL,
    CONSTRAINT [PK_Fornecedor_Regime_ST] PRIMARY KEY CLUSTERED ([cd_fornecedor] ASC, [cd_classificacao_fiscal] ASC, [cd_estado] ASC),
    CONSTRAINT [FK_Fornecedor_Regime_ST_Estado] FOREIGN KEY ([cd_estado]) REFERENCES [dbo].[Estado] ([cd_estado])
);

