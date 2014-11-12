CREATE TABLE [dbo].[Pedido_Venda_Item_Embalagem] (
    [cd_pedido_venda]         INT        NOT NULL,
    [cd_item_pedido_venda]    INT        NOT NULL,
    [cd_tipo_embalagem]       INT        NULL,
    [qt_embalagem]            FLOAT (53) NULL,
    [ic_incluso_embalagem]    CHAR (1)   NULL,
    [ic_aluguel_embalagem]    CHAR (1)   NULL,
    [qt_dia_cobrar_aluguel]   INT        NULL,
    [ic_embalagem_cliente]    CHAR (1)   NULL,
    [qt_capacidade_embalagem] FLOAT (53) NULL,
    [qt_peso_embalagem]       FLOAT (53) NULL,
    [dt_usuario]              DATETIME   NULL,
    [cd_usuario]              INT        NULL,
    [ic_tipo_retira]          CHAR (1)   NULL,
    [ic_frete_cliente]        CHAR (1)   NULL,
    CONSTRAINT [PK_Pedido_Venda_Item_Embalagem] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC, [cd_item_pedido_venda] ASC) WITH (FILLFACTOR = 90)
);

