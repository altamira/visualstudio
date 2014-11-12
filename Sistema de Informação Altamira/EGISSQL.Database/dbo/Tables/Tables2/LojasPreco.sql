CREATE TABLE [dbo].[LojasPreco] (
    [Loja]        VARCHAR (40) NOT NULL,
    [Localizacao] VARCHAR (30) NOT NULL,
    [Estado]      VARCHAR (30) NULL,
    [Categoria]   VARCHAR (40) NOT NULL,
    [Marca]       VARCHAR (30) NULL,
    [Produto]     VARCHAR (30) NULL,
    [Campo]       DECIMAL (16) NULL,
    [Status]      INT          NULL
);

