CREATE TABLE [dbo].[Funcionario_Habilidade] (
    [cd_funcionario]           INT          NOT NULL,
    [cd_cargo_habilidade]      INT          NOT NULL,
    [cd_cargo_peso]            INT          NOT NULL,
    [nm_obs_funcionario_habil] VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Funcionario_Habilidade] PRIMARY KEY CLUSTERED ([cd_funcionario] ASC, [cd_cargo_habilidade] ASC, [cd_cargo_peso] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Funcionario_Habilidade_Cargo_Peso] FOREIGN KEY ([cd_cargo_peso]) REFERENCES [dbo].[Cargo_Peso] ([cd_cargo_peso])
);

