CREATE TABLE [dbo].[Movimento_Caixa_Pedido] (
    [cd_movimento_caixa]    INT        NOT NULL,
    [cd_contador_pedido]    INT        NOT NULL,
    [cd_pedido_venda]       INT        NULL,
    [cd_condicao_pagamento] INT        NULL,
    [vl_custo_financeiro]   MONEY      NULL,
    [vl_total_pedido]       MONEY      NULL,
    [cd_tipo_local_entrega] INT        NOT NULL,
    [vl_tx_mensal_cust_fin] FLOAT (53) NULL,
    [vl_total_itens]        MONEY      NULL,
    [vl_total_frete]        MONEY      NULL,
    [ic_custo_fin_digitado] CHAR (1)   NULL,
    CONSTRAINT [PK_Movimento_Caixa_Pedido] PRIMARY KEY CLUSTERED ([cd_movimento_caixa] ASC, [cd_contador_pedido] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Movimento_Caixa_Pedido_Movimento_Caixa] FOREIGN KEY ([cd_movimento_caixa]) REFERENCES [dbo].[Movimento_Caixa] ([cd_movimento_caixa]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_Movimento_Caixa_Pedido_Tipo_Local_Entrega] FOREIGN KEY ([cd_tipo_local_entrega]) REFERENCES [dbo].[Tipo_Local_Entrega] ([cd_tipo_local_entrega])
);

