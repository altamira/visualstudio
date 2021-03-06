﻿CREATE TABLE [dbo].[Movimento_Caixa_Item] (
    [cd_movimento_caixa]      INT        NOT NULL,
    [cd_item_movimento_caixa] INT        NOT NULL,
    [cd_produto]              INT        NULL,
    [qt_item_movimento_caixa] FLOAT (53) NULL,
    [vl_item_movimento_caixa] MONEY      NULL,
    [vl_produto]              MONEY      NULL,
    [pc_desc_movimento_caixa] FLOAT (53) NULL,
    [vl_total_item]           MONEY      NULL,
    [dt_cancel_item]          DATETIME   NULL,
    [ic_estoque_movimento]    CHAR (1)   NULL,
    [cd_usuario]              INT        NULL,
    [dt_usuario]              DATETIME   NULL,
    [vl_descontado]           MONEY      NULL,
    [cd_cor_item]             INT        NULL,
    [pc_icms]                 FLOAT (53) NULL,
    [pc_reducao_icms]         FLOAT (53) NULL,
    [vl_lista_item]           MONEY      NULL,
    [qt_dias_entrega_medio]   INT        NULL,
    [dt_entrega]              DATETIME   NULL,
    [cd_pedido_venda]         INT        NULL,
    [cd_contador_pedido]      INT        NULL,
    [ic_sel_fechamento]       CHAR (1)   NULL,
    [cd_tipo_local_entrega]   INT        NOT NULL,
    [ic_cobrar_frete]         CHAR (1)   NULL,
    [vl_frete]                MONEY      NULL,
    [ic_cobrar_montagem]      CHAR (1)   NULL,
    [vl_montagem]             MONEY      NULL,
    [ic_frete_digitado]       CHAR (1)   NULL,
    [cd_item_pedido_venda]    INT        NULL,
    [ic_desconto_acima]       CHAR (1)   NULL,
    [cd_cupom_fiscal]         INT        NULL,
    [sg_unidade_medida]       CHAR (10)  NULL,
    [cd_unidade_medida]       INT        NULL,
    CONSTRAINT [PK_Movimento_Caixa_Item] PRIMARY KEY CLUSTERED ([cd_movimento_caixa] ASC, [cd_item_movimento_caixa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Movimento_Caixa_Item_Movimento_Caixa] FOREIGN KEY ([cd_movimento_caixa]) REFERENCES [dbo].[Movimento_Caixa] ([cd_movimento_caixa]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_Movimento_Caixa_Item_Tipo_Local_Entrega] FOREIGN KEY ([cd_tipo_local_entrega]) REFERENCES [dbo].[Tipo_Local_Entrega] ([cd_tipo_local_entrega])
);

