CREATE TABLE [dbo].[Grupo_Funcionario] (
    [cd_grupo_funcionario] INT          NOT NULL,
    [nm_grupo_funcionario] VARCHAR (40) NULL,
    [nm_fantasia_grupo]    VARCHAR (15) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Grupo_Funcionario] PRIMARY KEY CLUSTERED ([cd_grupo_funcionario] ASC) WITH (FILLFACTOR = 90)
);

