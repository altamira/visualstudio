CREATE TABLE [dbo].[Grupo_Salario] (
    [cd_grupo_salario] INT          NOT NULL,
    [nm_grupo_salario] VARCHAR (40) NULL,
    [sg_grupo_salario] CHAR (10)    NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Grupo_Salario] PRIMARY KEY CLUSTERED ([cd_grupo_salario] ASC) WITH (FILLFACTOR = 90)
);

