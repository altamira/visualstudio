CREATE TABLE [dbo].[Motivo_Ocorrencia_Veiculo] (
    [cd_mot_ocorrencia_veiculo] INT          NOT NULL,
    [nm_mot_ocorrencia_veiculo] VARCHAR (40) NULL,
    [sg_mot_ocorrencia_veiculo] CHAR (10)    NULL,
    [ic_pad_ocorrencia_veiculo] CHAR (1)     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Ocorrencia_Veiculo] PRIMARY KEY CLUSTERED ([cd_mot_ocorrencia_veiculo] ASC) WITH (FILLFACTOR = 90)
);

