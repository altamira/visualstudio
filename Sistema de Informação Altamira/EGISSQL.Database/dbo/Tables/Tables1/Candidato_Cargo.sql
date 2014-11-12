CREATE TABLE [dbo].[Candidato_Cargo] (
    [cd_candidato] INT      NOT NULL,
    [cd_cargo]     INT      NOT NULL,
    [cd_usuario]   INT      NULL,
    [dt_usuario]   DATETIME NULL,
    CONSTRAINT [PK_Candidato_Cargo] PRIMARY KEY CLUSTERED ([cd_candidato] ASC, [cd_cargo] ASC) WITH (FILLFACTOR = 90)
);

