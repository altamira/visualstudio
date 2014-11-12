CREATE TABLE [dbo].[Grupo_Exercicio] (
    [cd_grupo_exercicio] INT          NOT NULL,
    [nm_grupo_exercicio] VARCHAR (40) NULL,
    [sg_grupo_exercicio] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Grupo_Exercicio] PRIMARY KEY CLUSTERED ([cd_grupo_exercicio] ASC) WITH (FILLFACTOR = 90)
);

