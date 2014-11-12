CREATE TABLE [dbo].[Veiculo_Seguro] (
    [cd_veiculo_seguro]     INT          NOT NULL,
    [dt_veiculo_seguro]     DATETIME     NULL,
    [cd_veiculo]            INT          NULL,
    [cd_seguradora]         INT          NULL,
    [cd_apolice_seguro]     INT          NULL,
    [nm_obs_veiculo_seguro] VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Veiculo_Seguro] PRIMARY KEY CLUSTERED ([cd_veiculo_seguro] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Veiculo_Seguro_Apolice_Seguro] FOREIGN KEY ([cd_apolice_seguro]) REFERENCES [dbo].[Apolice_Seguro] ([cd_apolice_seguro])
);

