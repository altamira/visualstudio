CREATE TABLE [dbo].[Ordem_Carregamento] (
    [cd_ordem_carga]         INT          NOT NULL,
    [dt_ordem_carga]         DATETIME     NULL,
    [dt_prevista_entrega]    DATETIME     NULL,
    [cd_itinerario]          INT          NULL,
    [cd_veiculo]             INT          NULL,
    [cd_motorista]           INT          NULL,
    [dt_saida_ordem_carga]   DATETIME     NULL,
    [dt_entrega_ordem_carga] DATETIME     NULL,
    [dt_retorno_ordem_carga] DATETIME     NULL,
    [qt_km_inicial_veiculo]  FLOAT (53)   NULL,
    [qt_km_final_veiculo]    FLOAT (53)   NULL,
    [ds_ordem_carga]         TEXT         NULL,
    [nm_obs_ordem_carga]     VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Ordem_Carregamento] PRIMARY KEY CLUSTERED ([cd_ordem_carga] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Ordem_Carregamento_Motorista] FOREIGN KEY ([cd_motorista]) REFERENCES [dbo].[Motorista] ([cd_motorista])
);

