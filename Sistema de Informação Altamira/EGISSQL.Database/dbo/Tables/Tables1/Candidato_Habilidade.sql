CREATE TABLE [dbo].[Candidato_Habilidade] (
    [cd_candidato]           INT          NOT NULL,
    [cd_cargo_habilidade]    INT          NOT NULL,
    [cd_cargo_peso]          INT          NOT NULL,
    [nm_obs_candidato_habil] VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Candidato_Habilidade] PRIMARY KEY CLUSTERED ([cd_candidato] ASC, [cd_cargo_habilidade] ASC, [cd_cargo_peso] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Candidato_Habilidade_Cargo_Peso] FOREIGN KEY ([cd_cargo_peso]) REFERENCES [dbo].[Cargo_Peso] ([cd_cargo_peso])
);

