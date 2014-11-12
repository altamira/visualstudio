CREATE TABLE [dbo].[Pesquisa_Salarial] (
    [cd_pesquisa_salarial]      INT          NOT NULL,
    [dt_ini_pesquisa_salarial]  DATETIME     NULL,
    [dt_fim_pesquisa_salarial]  DATETIME     NULL,
    [cd_cargo_funcionario]      INT          NULL,
    [vl_pesquisa_salarial]      FLOAT (53)   NULL,
    [cd_fonte_pesquisa_salario] INT          NULL,
    [cd_tipo_pesquisa_salario]  INT          NULL,
    [nm_obs_pesquisa_salarial]  VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Pesquisa_Salarial] PRIMARY KEY CLUSTERED ([cd_pesquisa_salarial] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Pesquisa_Salarial_Cargo_Funcionario] FOREIGN KEY ([cd_cargo_funcionario]) REFERENCES [dbo].[Cargo_Funcionario] ([cd_cargo_funcionario]),
    CONSTRAINT [FK_Pesquisa_Salarial_Fonte_Pesquisa_Salario] FOREIGN KEY ([cd_fonte_pesquisa_salario]) REFERENCES [dbo].[Fonte_Pesquisa_Salario] ([cd_fonte_pesquisa_salario]),
    CONSTRAINT [FK_Pesquisa_Salarial_Tipo_Pesquisa_Salario] FOREIGN KEY ([cd_tipo_pesquisa_salario]) REFERENCES [dbo].[Tipo_Pesquisa_Salario] ([cd_tipo_pesquisa_salario])
);

