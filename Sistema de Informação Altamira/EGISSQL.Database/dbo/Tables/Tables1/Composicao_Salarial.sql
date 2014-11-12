CREATE TABLE [dbo].[Composicao_Salarial] (
    [cd_composicao_salarial] INT        NOT NULL,
    [cd_categoria_salario]   INT        NULL,
    [cd_departamento]        INT        NULL,
    [cd_cargo]               INT        NULL,
    [cd_faixa_salarial]      INT        NULL,
    [vl_composicao_salarial] FLOAT (53) NULL,
    [cd_usuario]             INT        NULL,
    [dt_usuario]             DATETIME   NULL,
    [cd_cargo_funcionario]   INT        NULL,
    [cd_fonte_pesquisa]      INT        NULL,
    [dt_inicial]             DATETIME   NULL,
    [dt_final]               DATETIME   NULL,
    [cd_grupo_salario]       INT        NULL,
    [cd_centro_custo]        INT        NULL,
    CONSTRAINT [PK_Composicao_Salarial] PRIMARY KEY CLUSTERED ([cd_composicao_salarial] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Composicao_Salarial_Cargo_Funcionario] FOREIGN KEY ([cd_cargo_funcionario]) REFERENCES [dbo].[Cargo_Funcionario] ([cd_cargo_funcionario]),
    CONSTRAINT [FK_Composicao_Salarial_Centro_Custo] FOREIGN KEY ([cd_centro_custo]) REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo]),
    CONSTRAINT [FK_Composicao_Salarial_Faixa_Salarial] FOREIGN KEY ([cd_faixa_salarial]) REFERENCES [dbo].[Faixa_Salarial] ([cd_faixa_salarial]),
    CONSTRAINT [FK_Composicao_Salarial_Fonte_Pesquisa_Salario] FOREIGN KEY ([cd_fonte_pesquisa]) REFERENCES [dbo].[Fonte_Pesquisa_Salario] ([cd_fonte_pesquisa_salario]),
    CONSTRAINT [FK_Composicao_Salarial_Grupo_Salario] FOREIGN KEY ([cd_grupo_salario]) REFERENCES [dbo].[Grupo_Salario] ([cd_grupo_salario])
);

