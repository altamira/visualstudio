CREATE TABLE [dbo].[Eleitores] (
    [eleitor_cpf]  NVARCHAR (15) COLLATE Latin1_General_CI_AS NOT NULL,
    [eleitor_nome] NVARCHAR (50) COLLATE Latin1_General_CI_AS NULL,
    CONSTRAINT [PK_Eleitor] PRIMARY KEY CLUSTERED ([eleitor_cpf] ASC) WITH (FILLFACTOR = 90)
);

