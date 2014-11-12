CREATE TABLE [dbo].[Classificacao_Residuo] (
    [cd_classificacao_residuo] INT          NOT NULL,
    [nm_classificacao_residuo] VARCHAR (40) NULL,
    [sg_classificacao_residuo] CHAR (10)    NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Classificacao_Residuo] PRIMARY KEY CLUSTERED ([cd_classificacao_residuo] ASC) WITH (FILLFACTOR = 90)
);

