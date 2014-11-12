CREATE TABLE [dbo].[Veiculo_Servico] (
    [cd_veiculo_servico]      INT          NOT NULL,
    [cd_veiculo]              INT          NOT NULL,
    [dt_servico_veiculo]      DATETIME     NOT NULL,
    [cd_tipo_servico_veiculo] INT          NULL,
    [qt_km_servico_veiculo]   INT          NULL,
    [qt_km_proximo_servico]   INT          NULL,
    [nm_obs_servico_veiculo]  VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Veiculo_Servico] PRIMARY KEY CLUSTERED ([cd_veiculo_servico] ASC, [dt_servico_veiculo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Veiculo_Servico_Tipo_Servico_Veiculo] FOREIGN KEY ([cd_tipo_servico_veiculo]) REFERENCES [dbo].[Tipo_Servico_Veiculo] ([cd_tipo_servico_veiculo])
);

