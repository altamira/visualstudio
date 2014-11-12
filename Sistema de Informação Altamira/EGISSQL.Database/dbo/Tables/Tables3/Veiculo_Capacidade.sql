CREATE TABLE [dbo].[Veiculo_Capacidade] (
    [cd_veiculo_capacidade]     INT          NOT NULL,
    [cd_veiculo]                INT          NOT NULL,
    [qt_peso_bruto_veiculo]     FLOAT (53)   NULL,
    [qt_volume_veiculo]         FLOAT (53)   NULL,
    [cd_tipo_embalagem]         INT          NULL,
    [nm_obs_veiculo_capacidade] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Veiculo_Capacidade] PRIMARY KEY CLUSTERED ([cd_veiculo_capacidade] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Veiculo_Capacidade_Tipo_Embalagem] FOREIGN KEY ([cd_tipo_embalagem]) REFERENCES [dbo].[Tipo_Embalagem] ([cd_tipo_embalagem])
);

