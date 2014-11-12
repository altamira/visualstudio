CREATE TABLE [dbo].[ListaFatoresCalculo] (
    [idListaFatorCalculo] INT           IDENTITY (1, 1) NOT NULL,
    [ListaFatorCalculo]   NVARCHAR (20) NULL,
    [Ativa]               BIT           NULL,
    [Padrao]              BIT           NULL
);

