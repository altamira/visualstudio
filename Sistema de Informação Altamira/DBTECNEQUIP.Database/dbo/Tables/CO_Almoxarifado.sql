CREATE TABLE [dbo].[CO_Almoxarifado] (
    [coal_Codigo]    CHAR (9)        NOT NULL,
    [coal_Descricao] CHAR (40)       NOT NULL,
    [coal_Unidade]   CHAR (2)        NOT NULL,
    [coal_Saldo]     NUMERIC (18, 3) NOT NULL,
    [coal_QtdMinima] INT             NOT NULL,
    [coal_Pasta]     TINYINT         NULL,
    [coal_Servico]   TINYINT         NULL,
    [coal_Valor]     MONEY           NOT NULL,
    [coal_Lock]      ROWVERSION      NOT NULL,
    CONSTRAINT [PK___2__13] PRIMARY KEY CLUSTERED ([coal_Codigo] ASC) WITH (FILLFACTOR = 90)
);

