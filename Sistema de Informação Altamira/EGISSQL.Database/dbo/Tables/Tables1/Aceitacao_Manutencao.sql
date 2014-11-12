CREATE TABLE [dbo].[Aceitacao_Manutencao] (
    [cd_aceitacao_manutencao] INT          NOT NULL,
    [nm_aceitacao_manutencao] VARCHAR (40) NULL,
    [sg_aceitacao_manutencao] CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Aceitacao_Manutencao] PRIMARY KEY CLUSTERED ([cd_aceitacao_manutencao] ASC) WITH (FILLFACTOR = 90)
);

