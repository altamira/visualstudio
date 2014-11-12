CREATE TABLE [dbo].[Arbitration_Clause_Idioma] (
    [cd_arbitration_clause_idioma] INT      NOT NULL,
    [ds_arbitration_clause_idioma] TEXT     NULL,
    [cd_usuario]                   INT      NULL,
    [dt_usuario]                   DATETIME NULL,
    [cd_arbitration_clause]        INT      NOT NULL,
    CONSTRAINT [PK_Arbitration_Clause_Idioma] PRIMARY KEY CLUSTERED ([cd_arbitration_clause_idioma] ASC, [cd_arbitration_clause] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Arbitration_Clause_Idioma_Idioma] FOREIGN KEY ([cd_arbitration_clause]) REFERENCES [dbo].[Idioma] ([cd_idioma])
);

