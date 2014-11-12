CREATE TABLE [dbo].[TransferPricing] (
    [nm_fantasia_produto]   VARCHAR (30) NOT NULL,
    [qt_item_venda]         FLOAT (53)   NULL,
    [vl_medio_venda]        FLOAT (53)   NULL,
    [qt_item_compra]        FLOAT (53)   NULL,
    [vl_medio_compra]       FLOAT (53)   NULL,
    [vl_diferenca]          FLOAT (53)   NULL,
    [vl_margem_divergencia] FLOAT (53)   NULL,
    [vl_transferpricing]    FLOAT (53)   NULL,
    CONSTRAINT [PK_TransferPricing] PRIMARY KEY CLUSTERED ([nm_fantasia_produto] ASC) WITH (FILLFACTOR = 90)
);

