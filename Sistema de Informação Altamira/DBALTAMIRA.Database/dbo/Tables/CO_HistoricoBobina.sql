CREATE TABLE [dbo].[CO_HistoricoBobina] (
    [cohb_Codigo]     CHAR (9)        NOT NULL,
    [cohb_Movimento]  CHAR (1)        NOT NULL,
    [cohb_Nota]       CHAR (6)        NULL,
    [cohb_Pedido]     INT             NULL,
    [cohb_Data]       SMALLDATETIME   NOT NULL,
    [cohb_Quantidade] DECIMAL (18, 3) NOT NULL,
    [cohb_Lock]       BINARY (8)      NULL
);

