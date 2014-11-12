CREATE TABLE [dbo].[FormulaCalculo] (
    [idFormula]           INT            IDENTITY (1, 1) NOT NULL,
    [idListaFatorCalculo] INT            NULL,
    [DescricaoFormula]    NVARCHAR (255) NULL,
    [Formula]             NVARCHAR (MAX) NULL,
    [FormulaDetalhe]      NVARCHAR (MAX) NULL,
    [ReferentePreco]      INT            NULL
);

