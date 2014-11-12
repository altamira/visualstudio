CREATE TABLE [dbo].[Categoria_Salario] (
    [cd_categoria_salario]   INT          NOT NULL,
    [nm_categoria_salario]   VARCHAR (40) NULL,
    [sg_categoria_salario]   CHAR (10)    NULL,
    [cd_mascara_cat_salario] VARCHAR (20) NULL,
    [cd_grupo_salario]       INT          NULL,
    [cd_grupo_salario_pai]   INT          NULL,
    [cd_nivel_cat_salario]   INT          NULL,
    [vl_categoria_salario]   FLOAT (53)   NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [cd_tipo_salario]        INT          NULL,
    CONSTRAINT [PK_Categoria_Salario] PRIMARY KEY CLUSTERED ([cd_categoria_salario] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Categoria_Salario_Grupo_Salario] FOREIGN KEY ([cd_grupo_salario]) REFERENCES [dbo].[Grupo_Salario] ([cd_grupo_salario])
);

