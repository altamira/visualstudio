CREATE TABLE [dbo].[Centro_Custo_Nota_Entrada] (
    [cd_nota_entrada]           INT        NOT NULL,
    [dt_usuario]                DATETIME   NULL,
    [cd_usuario]                INT        NULL,
    [vl_centro_custo_nota]      FLOAT (53) NULL,
    [cd_departamento]           INT        NULL,
    [cd_centro_custo]           INT        NULL,
    [cd_centro_custo_nt_entrad] INT        NOT NULL,
    CONSTRAINT [PK_Centro_Custo_Nota_Entrada] PRIMARY KEY CLUSTERED ([cd_nota_entrada] ASC, [cd_centro_custo_nt_entrad] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Centro_Custo_Nota_Entrada_Centro_Custo] FOREIGN KEY ([cd_centro_custo]) REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo]),
    CONSTRAINT [FK_Centro_Custo_Nota_Entrada_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento])
);

