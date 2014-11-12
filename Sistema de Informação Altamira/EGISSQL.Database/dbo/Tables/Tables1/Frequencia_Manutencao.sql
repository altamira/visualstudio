CREATE TABLE [dbo].[Frequencia_Manutencao] (
    [cd_frequencia_manutencao] INT          NOT NULL,
    [nm_frequencia_manutencao] VARCHAR (40) NULL,
    [sg_frequencia_manutencao] CHAR (10)    NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Frequencia_Manutencao] PRIMARY KEY CLUSTERED ([cd_frequencia_manutencao] ASC) WITH (FILLFACTOR = 90)
);

