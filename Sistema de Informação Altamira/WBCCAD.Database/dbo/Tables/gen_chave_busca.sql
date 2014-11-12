CREATE TABLE [dbo].[gen_chave_busca] (
    [indice]            INT            IDENTITY (1, 1) NOT NULL,
    [nome]              NVARCHAR (50)  NULL,
    [sigla]             NVARCHAR (50)  NULL,
    [descritivoTecnico] NVARCHAR (MAX) NULL,
    [EsconderOrcamento] BIT            NULL
);

