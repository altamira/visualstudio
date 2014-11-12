CREATE TABLE [dbo].[Servico_Modelo_Veiculo] (
    [cd_servico]             INT          NOT NULL,
    [cd_modelo_veiculo]      INT          NOT NULL,
    [ic_km_servico_modelo]   CHAR (1)     NULL,
    [ic_dia_servico_modelo]  CHAR (1)     NULL,
    [ic_terc_servico_modelo] CHAR (1)     NULL,
    [nm_obs_servico_modelo]  VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [qt_servico_modelo]      FLOAT (53)   NULL,
    [qt_hora_servico]        FLOAT (53)   NULL,
    CONSTRAINT [PK_Servico_Modelo_Veiculo] PRIMARY KEY CLUSTERED ([cd_servico] ASC, [cd_modelo_veiculo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Servico_Modelo_Veiculo_Modelo_Veiculo] FOREIGN KEY ([cd_modelo_veiculo]) REFERENCES [dbo].[Modelo_Veiculo] ([cd_modelo_veiculo])
);

