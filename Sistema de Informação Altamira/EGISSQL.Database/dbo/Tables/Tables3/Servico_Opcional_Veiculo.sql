CREATE TABLE [dbo].[Servico_Opcional_Veiculo] (
    [cd_servico]          INT          NOT NULL,
    [cd_opcional]         INT          NOT NULL,
    [qt_servico_opcional] FLOAT (53)   NULL,
    [ic_km_servico]       CHAR (1)     NULL,
    [ic_dia_servico]      CHAR (1)     NULL,
    [ic_terc_servico]     CHAR (1)     NULL,
    [nm_obs_servico]      VARCHAR (40) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Servico_Opcional_Veiculo] PRIMARY KEY CLUSTERED ([cd_servico] ASC, [cd_opcional] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Servico_Opcional_Veiculo_Opcional_Veiculo] FOREIGN KEY ([cd_opcional]) REFERENCES [dbo].[Opcional_Veiculo] ([cd_opcional])
);

