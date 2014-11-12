CREATE TABLE [dbo].[Cliente_Regime_ST] (
    [cd_cliente]              INT          NOT NULL,
    [cd_classificacao_fiscal] INT          NOT NULL,
    [cd_estado]               INT          NOT NULL,
    [pc_icms_strib_cliente]   FLOAT (53)   NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [nm_obs_cliente_regime]   VARCHAR (40) NULL,
    CONSTRAINT [PK_Cliente_Regime_ST] PRIMARY KEY CLUSTERED ([cd_cliente] ASC, [cd_classificacao_fiscal] ASC, [cd_estado] ASC),
    CONSTRAINT [FK_Cliente_Regime_ST_Estado] FOREIGN KEY ([cd_estado]) REFERENCES [dbo].[Estado] ([cd_estado])
);

