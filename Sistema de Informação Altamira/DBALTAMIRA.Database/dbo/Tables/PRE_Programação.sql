CREATE TABLE [dbo].[PRE_Programação] (
    [pros_NumOS]        FLOAT (53)    NOT NULL,
    [pros_NumPedido]    FLOAT (53)    NULL,
    [pros_NumOrcamento] FLOAT (53)    NULL,
    [pros_cliente]      VARCHAR (50)  NULL,
    [pros_DataPedido]   SMALLDATETIME NULL,
    [pros_DataEntrega]  SMALLDATETIME NULL,
    [pros_Observação]   TEXT          NULL,
    CONSTRAINT [PK_PRE_Programação] PRIMARY KEY NONCLUSTERED ([pros_NumOS] ASC) WITH (FILLFACTOR = 90)
);

