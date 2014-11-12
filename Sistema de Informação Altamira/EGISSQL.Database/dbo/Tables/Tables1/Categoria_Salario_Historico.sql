CREATE TABLE [dbo].[Categoria_Salario_Historico] (
    [cd_cat_salario_historico] INT        NOT NULL,
    [cd_categoria_salario]     INT        NULL,
    [dt_historico_cat_salario] DATETIME   NULL,
    [vl_historico_cat_salario] FLOAT (53) NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    CONSTRAINT [PK_Categoria_Salario_Historico] PRIMARY KEY CLUSTERED ([cd_cat_salario_historico] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Categoria_Salario_Historico_Categoria_Salario] FOREIGN KEY ([cd_categoria_salario]) REFERENCES [dbo].[Categoria_Salario] ([cd_categoria_salario])
);

