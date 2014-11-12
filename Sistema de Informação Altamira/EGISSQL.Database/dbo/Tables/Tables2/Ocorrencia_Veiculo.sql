CREATE TABLE [dbo].[Ocorrencia_Veiculo] (
    [cd_ocorrencia_veiculo]     INT          NOT NULL,
    [dt_ocorrencia_veiculo]     DATETIME     NULL,
    [cd_veiculo]                INT          NULL,
    [cd_motorista]              INT          NULL,
    [cd_mot_ocorrencia_veiculo] INT          NULL,
    [ds_ocorrencia_veiculo]     TEXT         NULL,
    [nm_obs_ocorrencia_veiculo] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Ocorrencia_Veiculo] PRIMARY KEY CLUSTERED ([cd_ocorrencia_veiculo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Ocorrencia_Veiculo_Motivo_Ocorrencia_Veiculo] FOREIGN KEY ([cd_mot_ocorrencia_veiculo]) REFERENCES [dbo].[Motivo_Ocorrencia_Veiculo] ([cd_mot_ocorrencia_veiculo])
);

