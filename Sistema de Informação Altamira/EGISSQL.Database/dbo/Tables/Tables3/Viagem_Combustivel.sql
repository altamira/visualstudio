CREATE TABLE [dbo].[Viagem_Combustivel] (
    [cd_viagem]          INT          NOT NULL,
    [dt_viagem]          DATETIME     NULL,
    [dt_retirada_viagem] DATETIME     NULL,
    [cd_motorista]       INT          NULL,
    [cd_veiculo]         INT          NULL,
    [cd_pedido_venda]    INT          NULL,
    [qt_ordem_viagem]    INT          NULL,
    [ds_viagem]          TEXT         NULL,
    [nm_obs_viagem]      VARCHAR (60) NULL,
    [vl_total_viagem]    FLOAT (53)   NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    [cd_bandeira]        INT          NULL,
    [cd_destino]         INT          NULL,
    CONSTRAINT [PK_Viagem_Combustivel] PRIMARY KEY CLUSTERED ([cd_viagem] ASC),
    CONSTRAINT [FK_Viagem_Combustivel_Veiculo] FOREIGN KEY ([cd_veiculo]) REFERENCES [dbo].[Veiculo] ([cd_veiculo])
);

