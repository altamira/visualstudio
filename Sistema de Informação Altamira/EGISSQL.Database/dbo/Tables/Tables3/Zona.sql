CREATE TABLE [dbo].[Zona] (
    [cd_pais]    INT          NOT NULL,
    [cd_estado]  INT          NOT NULL,
    [cd_cidade]  INT          NOT NULL,
    [cd_regiao]  INT          NOT NULL,
    [cd_zona]    INT          NOT NULL,
    [nm_zona]    VARCHAR (30) NOT NULL,
    [sg_zona]    CHAR (10)    NULL,
    [cd_usuario] INT          NULL,
    [dt_usuario] DATETIME     NULL,
    CONSTRAINT [PK_Zona] PRIMARY KEY CLUSTERED ([cd_pais] ASC, [cd_estado] ASC, [cd_cidade] ASC, [cd_regiao] ASC, [cd_zona] ASC) WITH (FILLFACTOR = 90)
);

