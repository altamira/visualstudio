CREATE TABLE [dbo].[CO_HistoricoBobina] (
    [cohb_Codigo]     CHAR (9)        NOT NULL,
    [cohb_Movimento]  CHAR (1)        NOT NULL,
    [cohb_Nota]       CHAR (6)        NULL,
    [cohb_Pedido]     INT             NULL,
    [cohb_Data]       SMALLDATETIME   NOT NULL,
    [cohb_Quantidade] NUMERIC (18, 3) NOT NULL,
    [cohb_Lock]       ROWVERSION      NOT NULL,
    CONSTRAINT [FK_CO_Historic_CO_Almoxari] FOREIGN KEY ([cohb_Codigo]) REFERENCES [dbo].[CO_Almoxarifado] ([coal_Codigo])
);


GO
CREATE CLUSTERED INDEX [IX_CO_HistoricoBobina]
    ON [dbo].[CO_HistoricoBobina]([cohb_Codigo] ASC) WITH (FILLFACTOR = 90);

