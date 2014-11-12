CREATE TABLE [dbo].[Motivo_Baixa_Veiculo] (
    [cd_motivo_baixa_veiculo]  INT          NOT NULL,
    [nm_motivo_baixa_veiculo]  VARCHAR (30) NULL,
    [sg_motivo_baixa_veiculo]  CHAR (10)    NULL,
    [ic_pad_mot_baixa_veiculo] CHAR (1)     NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Baixa_Veiculo] PRIMARY KEY CLUSTERED ([cd_motivo_baixa_veiculo] ASC) WITH (FILLFACTOR = 90)
);

