CREATE TABLE [dbo].[Cargo_Peso_Habilidade] (
    [cd_cargo_funcionario]    INT          NOT NULL,
    [cd_cargo_peso]           INT          NOT NULL,
    [cd_cargo_habilidade]     INT          NOT NULL,
    [nm_obs_cargo_peso_habil] VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Cargo_Peso_Habilidade] PRIMARY KEY CLUSTERED ([cd_cargo_funcionario] ASC, [cd_cargo_peso] ASC, [cd_cargo_habilidade] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cargo_Peso_Habilidade_Cargo_Habilidade] FOREIGN KEY ([cd_cargo_habilidade]) REFERENCES [dbo].[Cargo_Habilidade] ([cd_cargo_habilidade])
);

