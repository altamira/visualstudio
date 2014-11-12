CREATE TABLE [dbo].[Classificacao_Cliente] (
    [cd_classificacao_cliente] INT          NOT NULL,
    [nm_classificacao_cliente] VARCHAR (50) NULL,
    [sg_classificacao_cliente] CHAR (10)    NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Classificacao_Cliente] PRIMARY KEY CLUSTERED ([cd_classificacao_cliente] ASC)
);

