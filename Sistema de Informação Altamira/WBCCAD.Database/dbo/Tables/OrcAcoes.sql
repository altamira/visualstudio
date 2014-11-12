CREATE TABLE [dbo].[OrcAcoes] (
    [SEQUENCIAL]      INT            IDENTITY (1, 1) NOT NULL,
    [DESCRICAO]       NVARCHAR (100) NULL,
    [COMANDO1]        TEXT           NULL,
    [COMANDO2]        TEXT           NULL,
    [CANCELAR1]       TEXT           NULL,
    [CANCELAR2]       TEXT           NULL,
    [numeroOrcamento] NCHAR (9)      NULL,
    CONSTRAINT [PK_OrcAcoes] PRIMARY KEY CLUSTERED ([SEQUENCIAL] ASC)
);

