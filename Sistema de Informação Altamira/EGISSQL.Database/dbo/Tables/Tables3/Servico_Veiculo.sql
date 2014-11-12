CREATE TABLE [dbo].[Servico_Veiculo] (
    [cd_servico]              INT          NOT NULL,
    [nm_servico]              VARCHAR (60) NULL,
    [qt_frequencia_servico]   FLOAT (53)   NULL,
    [ic_km_servico]           CHAR (1)     NULL,
    [ic_dia_servico]          CHAR (1)     NULL,
    [ic_terceiro_servico]     CHAR (1)     NULL,
    [cd_local_oficina]        INT          NULL,
    [nm_obs_servico]          VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [qt_hora_servico_veiculo] FLOAT (53)   NULL,
    [cd_mao_obra]             INT          NULL,
    CONSTRAINT [PK_Servico_Veiculo] PRIMARY KEY CLUSTERED ([cd_servico] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Servico_Veiculo_Local_Oficina] FOREIGN KEY ([cd_local_oficina]) REFERENCES [dbo].[Local_Oficina] ([cd_local_oficina]),
    CONSTRAINT [FK_Servico_Veiculo_Mao_Obra] FOREIGN KEY ([cd_mao_obra]) REFERENCES [dbo].[Mao_Obra] ([cd_mao_obra])
);

