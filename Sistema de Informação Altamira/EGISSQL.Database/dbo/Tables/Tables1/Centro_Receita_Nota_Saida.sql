CREATE TABLE [dbo].[Centro_Receita_Nota_Saida] (
    [cd_nota_saida]          INT        NOT NULL,
    [cd_centro_receita_nota] INT        NOT NULL,
    [cd_centro_receita]      INT        NULL,
    [cd_departamento]        INT        NULL,
    [vl_centro_receita_nota] FLOAT (53) NULL,
    [cd_usuario]             INT        NULL,
    [dt_usuario]             DATETIME   NULL,
    CONSTRAINT [PK_Centro_Receita_Nota_Saida] PRIMARY KEY CLUSTERED ([cd_nota_saida] ASC, [cd_centro_receita_nota] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Centro_Receita_Nota_Saida_Centro_Receita] FOREIGN KEY ([cd_centro_receita]) REFERENCES [dbo].[Centro_Receita] ([cd_centro_receita]),
    CONSTRAINT [FK_Centro_Receita_Nota_Saida_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento])
);

