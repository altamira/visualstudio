CREATE TABLE [dbo].[PRE_AcomPedido] (
    [pros_NumOS]          FLOAT (53)    NOT NULL,
    [pros_NumPedido]      FLOAT (53)    NULL,
    [pros_NumOrcamento]   FLOAT (53)    NULL,
    [pros_cliente]        VARCHAR (50)  NULL,
    [pros_DataPedido]     SMALLDATETIME NULL,
    [pros_DataEntrega]    SMALLDATETIME NULL,
    [pros_Observação]     TEXT          NULL,
    [pros_Acompanhamento] CHAR (1)      NULL,
    [pros_Situação]       VARCHAR (50)  NULL,
    [pros_DataPrevisão]   SMALLDATETIME NULL,
    CONSTRAINT [PK_PRE_AcomPedido] PRIMARY KEY NONCLUSTERED ([pros_NumOS] ASC) WITH (FILLFACTOR = 90)
);

