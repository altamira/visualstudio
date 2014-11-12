CREATE TABLE [dbo].[CO_Almoxarifado] (
    [coal_Codigo]     CHAR (9)        NOT NULL,
    [coal_Descricao]  CHAR (100)      NOT NULL,
    [coal_Unidade]    CHAR (2)        NOT NULL,
    [coal_Saldo]      DECIMAL (18, 3) NOT NULL,
    [coal_QtdMinima]  INT             NOT NULL,
    [coal_Pasta]      TINYINT         NULL,
    [coal_Servico]    TINYINT         NULL,
    [coal_Valor]      MONEY           NOT NULL,
    [coal_Rendimento] FLOAT (53)      NULL,
    [coal_ECZ]        SMALLINT        NULL,
    [coal_Lock]       BINARY (8)      NULL,
    CONSTRAINT [PK_CO_Almoxarifado] PRIMARY KEY NONCLUSTERED ([coal_Codigo] ASC) WITH (FILLFACTOR = 90)
);

