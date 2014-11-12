CREATE TABLE [dbo].[Regiao] (
    [cd_pais]           INT          NOT NULL,
    [cd_estado]         INT          NOT NULL,
    [cd_cidade]         INT          NOT NULL,
    [cd_regiao]         INT          NOT NULL,
    [nm_regiao]         VARCHAR (30) NOT NULL,
    [sg_regiao]         CHAR (10)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    [ic_analise_regiao] CHAR (1)     NULL,
    CONSTRAINT [PK_Regiao] PRIMARY KEY CLUSTERED ([cd_pais] ASC, [cd_estado] ASC, [cd_cidade] ASC, [cd_regiao] ASC) WITH (FILLFACTOR = 90)
);

