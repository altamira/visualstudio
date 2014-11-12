CREATE TABLE [dbo].[CO_HistoricoChapa] (
    [cohc_Codigo]     CHAR (9)        NOT NULL,
    [cohc_Movimento]  CHAR (1)        NOT NULL,
    [cohc_Nota]       CHAR (6)        NULL,
    [cohc_Pedido]     INT             NULL,
    [cohc_Data]       SMALLDATETIME   NOT NULL,
    [cohc_Quantidade] NUMERIC (18, 3) NOT NULL,
    [cohc_Lock]       ROWVERSION      NOT NULL
);

