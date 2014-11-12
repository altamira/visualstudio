CREATE TABLE [dbo].[Veiculo_Baixa] (
    [cd_veiculo]              INT      NOT NULL,
    [dt_baixa_veiculo]        DATETIME NULL,
    [cd_motivo_baixa_veiculo] INT      NULL,
    [ds_baixa_veiculo]        TEXT     NULL,
    [cd_usuario]              INT      NULL,
    [dt_usuario]              DATETIME NULL,
    CONSTRAINT [PK_Veiculo_Baixa] PRIMARY KEY CLUSTERED ([cd_veiculo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Veiculo_Baixa_Motivo_Baixa_Veiculo] FOREIGN KEY ([cd_motivo_baixa_veiculo]) REFERENCES [dbo].[Motivo_Baixa_Veiculo] ([cd_motivo_baixa_veiculo])
);

