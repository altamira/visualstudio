CREATE TABLE [dbo].[Adiantamento] (
    [cd_adiantamento]       INT        NOT NULL,
    [dt_adiantamento]       DATETIME   NULL,
    [vl_adiantamento]       FLOAT (53) NULL,
    [vl_saldo_adiantamento] FLOAT (53) NULL,
    [cd_funcionario]        INT        NULL,
    [cd_centro_custo]       INT        NULL,
    [cd_departamento]       INT        NULL,
    [cd_vendedor]           INT        NULL,
    [cd_fornecedor]         INT        NULL,
    [cd_finalidade_despesa] INT        NULL,
    [dt_baixa_adiantamento] DATETIME   NULL,
    [cd_usuario]            INT        NULL,
    [dt_usuario]            DATETIME   NULL,
    CONSTRAINT [PK_Adiantamento] PRIMARY KEY CLUSTERED ([cd_adiantamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK__Centro_Custo] FOREIGN KEY ([cd_centro_custo]) REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo]),
    CONSTRAINT [FK__Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento]),
    CONSTRAINT [FK__Finalidade_Despesa] FOREIGN KEY ([cd_finalidade_despesa]) REFERENCES [dbo].[Finalidade_Despesa] ([cd_finalidade_despesa]),
    CONSTRAINT [FK__Fornecedor] FOREIGN KEY ([cd_fornecedor]) REFERENCES [dbo].[Fornecedor] ([cd_fornecedor]),
    CONSTRAINT [FK__Vendedor] FOREIGN KEY ([cd_vendedor]) REFERENCES [dbo].[Vendedor] ([cd_vendedor])
);

