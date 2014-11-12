CREATE TABLE [dbo].[Secao] (
    [idSecao]     INT            IDENTITY (1, 1) NOT NULL,
    [Secao]       NVARCHAR (255) NULL,
    [Ordem]       INT            NULL,
    [Observacoes] NVARCHAR (255) NULL,
    [Ativa]       BIT            NULL
);

