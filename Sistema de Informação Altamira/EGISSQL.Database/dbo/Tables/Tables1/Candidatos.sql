CREATE TABLE [dbo].[Candidatos] (
    [cand_codigo] INT           NOT NULL,
    [cand_nome]   NVARCHAR (50) COLLATE Latin1_General_CI_AS NULL,
    [cand_tipo]   NVARCHAR (2)  COLLATE Latin1_General_CI_AS NULL,
    CONSTRAINT [PK_Candidatos] PRIMARY KEY CLUSTERED ([cand_codigo] ASC) WITH (FILLFACTOR = 90)
);

