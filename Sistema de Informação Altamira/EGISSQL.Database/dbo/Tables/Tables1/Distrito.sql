CREATE TABLE [dbo].[Distrito] (
    [cd_pais]     INT          NOT NULL,
    [cd_estado]   INT          NOT NULL,
    [cd_cidade]   INT          NOT NULL,
    [cd_regiao]   INT          NOT NULL,
    [cd_zona]     INT          NOT NULL,
    [cd_distrito] INT          NOT NULL,
    [nm_distrito] VARCHAR (40) NOT NULL,
    [sg_distrito] CHAR (10)    NULL,
    [cd_usuario]  INT          NULL,
    [dt_usuario]  DATETIME     NULL,
    CONSTRAINT [PK_Distrito] PRIMARY KEY CLUSTERED ([cd_pais] ASC, [cd_estado] ASC, [cd_cidade] ASC, [cd_regiao] ASC, [cd_zona] ASC, [cd_distrito] ASC) WITH (FILLFACTOR = 90)
);

