CREATE TABLE [dbo].[Traducao] (
    [idTraducao]   INT            IDENTITY (1, 1) NOT NULL,
    [PalavraChave] NVARCHAR (MAX) NULL,
    [Complemento]  NVARCHAR (255) NULL,
    [TraducaoEN]   NVARCHAR (MAX) NULL,
    [TraducaoES]   NVARCHAR (MAX) NULL,
    [TraducaoPT]   NVARCHAR (MAX) NULL,
    [TraducaoIT]   NVARCHAR (MAX) NULL
);

