CREATE TABLE [dbo].[Frota_Cliente] (
    [cd_frota]             INT          NOT NULL,
    [cd_cliente]           INT          NOT NULL,
    [cd_veiculo]           INT          NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [nm_obs_frota_cliente] VARCHAR (40) NULL,
    [cd_motorista]         INT          NULL,
    CONSTRAINT [PK_Frota_Cliente] PRIMARY KEY CLUSTERED ([cd_frota] ASC, [cd_cliente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Frota_Cliente_Motorista] FOREIGN KEY ([cd_motorista]) REFERENCES [dbo].[Motorista] ([cd_motorista]),
    CONSTRAINT [FK_Frota_Cliente_Veiculo] FOREIGN KEY ([cd_veiculo]) REFERENCES [dbo].[Veiculo] ([cd_veiculo])
);

