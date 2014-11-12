CREATE TABLE [dbo].[Veiculo_Kilometragem] (
    [cd_controle_km_veiculo] INT          NOT NULL,
    [cd_veiculo]             INT          NOT NULL,
    [dt_km_veiculo]          DATETIME     NULL,
    [qt_km_veiculo]          FLOAT (53)   NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [nm_obs_km_veiculo]      VARCHAR (40) NULL,
    CONSTRAINT [PK_Veiculo_Kilometragem] PRIMARY KEY CLUSTERED ([cd_controle_km_veiculo] ASC) WITH (FILLFACTOR = 90)
);

