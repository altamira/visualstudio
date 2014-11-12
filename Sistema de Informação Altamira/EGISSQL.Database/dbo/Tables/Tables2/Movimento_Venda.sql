CREATE TABLE [dbo].[Movimento_Venda] (
    [cd_movimento_venda]       INT           NOT NULL,
    [dt_movimento_venda]       DATETIME      NULL,
    [cd_concessionaria]        INT           NULL,
    [dt_venda_concessionaria]  DATETIME      NULL,
    [cd_cliente]               INT           NULL,
    [cd_modelo_veiculo]        INT           NULL,
    [cd_cor]                   INT           NULL,
    [cd_nota_saida]            INT           NULL,
    [cd_vendedor]              INT           NULL,
    [qt_km_veiculo]            FLOAT (53)    NULL,
    [nm_foto_veiculo]          VARCHAR (100) NULL,
    [nm_obs_movimento_venda]   VARCHAR (40)  NULL,
    [cd_usuario]               INT           NULL,
    [dt_usuario]               DATETIME      NULL,
    [cd_identificacao_veiculo] VARCHAR (20)  NULL,
    CONSTRAINT [PK_Movimento_Venda] PRIMARY KEY CLUSTERED ([cd_movimento_venda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Movimento_Venda_Vendedor] FOREIGN KEY ([cd_vendedor]) REFERENCES [dbo].[Vendedor] ([cd_vendedor])
);

