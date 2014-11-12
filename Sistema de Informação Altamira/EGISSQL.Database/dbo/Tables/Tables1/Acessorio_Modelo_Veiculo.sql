CREATE TABLE [dbo].[Acessorio_Modelo_Veiculo] (
    [cd_acessorio_veiculo]    INT          NOT NULL,
    [cd_modelo_veiculo]       INT          NOT NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [nm_ref_acessorio_modelo] VARCHAR (40) NULL,
    CONSTRAINT [PK_Acessorio_Modelo_Veiculo] PRIMARY KEY CLUSTERED ([cd_acessorio_veiculo] ASC, [cd_modelo_veiculo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Acessorio_Modelo_Veiculo_Modelo_Veiculo] FOREIGN KEY ([cd_modelo_veiculo]) REFERENCES [dbo].[Modelo_Veiculo] ([cd_modelo_veiculo])
);

