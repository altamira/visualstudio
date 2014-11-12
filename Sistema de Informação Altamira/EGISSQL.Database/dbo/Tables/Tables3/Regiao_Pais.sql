CREATE TABLE [dbo].[Regiao_Pais] (
    [cd_regiao_pais] INT          NOT NULL,
    [nm_regiao_pais] VARCHAR (40) NULL,
    [sg_regiao_pais] CHAR (10)    NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Regiao_Pais] PRIMARY KEY CLUSTERED ([cd_regiao_pais] ASC) WITH (FILLFACTOR = 90)
);

