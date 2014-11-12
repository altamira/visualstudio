CREATE TABLE [dbo].[FatoresCalculo] (
    [idFator]             INT            NULL,
    [idListaFatorCalculo] INT            NULL,
    [Fator]               NVARCHAR (255) NULL,
    [ReferentePreco]      INT            NULL,
    [Variavel]            BIT            NOT NULL,
    [Visivel]             BIT            NOT NULL,
    [PertenceListaPreco]  BIT            NOT NULL,
    [Valor]               FLOAT (53)     NULL
);

