CREATE TABLE [dbo].[Utilizacao_Maquina] (
    [cd_utilizacao_maquina] INT          NOT NULL,
    [nm_utilizacao_maquina] VARCHAR (50) NULL,
    [sg_utilizacao_maquina] CHAR (10)    NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Utilizacao_Maquina] PRIMARY KEY CLUSTERED ([cd_utilizacao_maquina] ASC) WITH (FILLFACTOR = 90)
);

