CREATE TABLE [dbo].[Votacoes] (
    [eleitor_cpf] NVARCHAR (15) COLLATE Latin1_General_CI_AS NOT NULL,
    [cand_codigo] INT           NOT NULL,
    CONSTRAINT [PK_Votacoes] PRIMARY KEY CLUSTERED ([eleitor_cpf] ASC, [cand_codigo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Votacoes_Candidatos] FOREIGN KEY ([cand_codigo]) REFERENCES [dbo].[Candidatos] ([cand_codigo]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_Votacoes_Eleitores] FOREIGN KEY ([eleitor_cpf]) REFERENCES [dbo].[Eleitores] ([eleitor_cpf]) ON DELETE CASCADE ON UPDATE CASCADE
);

