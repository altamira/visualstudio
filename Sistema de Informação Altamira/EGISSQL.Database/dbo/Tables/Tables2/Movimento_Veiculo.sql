CREATE TABLE [dbo].[Movimento_Veiculo] (
    [cd_movimento_veiculo]     INT          NOT NULL,
    [dt_movimento_veiculo]     DATETIME     NULL,
    [cd_veiculo]               INT          NULL,
    [cd_motorista]             INT          NULL,
    [cd_tipo_servico_veiculo]  INT          NULL,
    [cd_tipo_combustivel]      INT          NULL,
    [cd_despesa_veiculo]       INT          NULL,
    [qt_movimento_veiculo]     FLOAT (53)   NULL,
    [vl_movimento_veiculo]     FLOAT (53)   NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [nm_obs_movimento_veiculo] VARCHAR (40) NULL,
    [cd_fornecedor]            INT          NULL,
    [qt_km_inicial_veiculo]    FLOAT (53)   NULL,
    [qt_km_validade_veiculo]   FLOAT (53)   NULL,
    CONSTRAINT [PK_Movimento_Veiculo] PRIMARY KEY CLUSTERED ([cd_movimento_veiculo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Movimento_Veiculo_Despesa_Veiculo] FOREIGN KEY ([cd_despesa_veiculo]) REFERENCES [dbo].[Despesa_Veiculo] ([cd_despesa_veiculo]),
    CONSTRAINT [FK_Movimento_Veiculo_Fornecedor] FOREIGN KEY ([cd_fornecedor]) REFERENCES [dbo].[Fornecedor] ([cd_fornecedor])
);

