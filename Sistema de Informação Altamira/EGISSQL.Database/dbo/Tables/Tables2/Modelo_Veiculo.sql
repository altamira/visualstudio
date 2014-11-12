CREATE TABLE [dbo].[Modelo_Veiculo] (
    [cd_modelo_veiculo]        INT          NOT NULL,
    [nm_modelo_veiculo]        VARCHAR (60) NULL,
    [ds_perfil_modelo_veiculo] TEXT         NULL,
    [cd_ano_modelo_veiculo]    INT          NULL,
    [cd_fab_modelo_veiculo]    INT          NULL,
    [cd_montadora]             INT          NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_tipo_combustivel]      INT          NULL,
    [cd_ref_modelo_veiculo]    VARCHAR (10) NULL,
    CONSTRAINT [PK_Modelo_Veiculo] PRIMARY KEY CLUSTERED ([cd_modelo_veiculo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Modelo_Veiculo_Montadora] FOREIGN KEY ([cd_montadora]) REFERENCES [dbo].[Montadora] ([cd_montadora]),
    CONSTRAINT [FK_Modelo_Veiculo_Tipo_Combustivel] FOREIGN KEY ([cd_tipo_combustivel]) REFERENCES [dbo].[Tipo_Combustivel] ([cd_tipo_combustivel])
);

