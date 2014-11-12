CREATE TABLE [dbo].[Calculo_Comissao] (
    [cd_calculo_comissao]      INT        NOT NULL,
    [cd_vendedor]              INT        NULL,
    [dt_inicio_calculo]        DATETIME   NULL,
    [dt_final_calculo]         DATETIME   NULL,
    [cd_item_calculo_comissao] INT        NULL,
    [cd_tipo_comissao]         INT        NULL,
    [cd_categoria_produto]     INT        NULL,
    [pc_calculo_comissao]      FLOAT (53) NULL,
    [vl_calculo_comissao]      MONEY      NULL,
    [cd_pedido_venda]          INT        NULL,
    [cd_item_pedido_venda]     INT        NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    [cd_grupo_categoria]       INT        NULL,
    CONSTRAINT [PK_Calculo_Comissao] PRIMARY KEY CLUSTERED ([cd_calculo_comissao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Calculo_Comissao_Pedido_Venda] FOREIGN KEY ([cd_pedido_venda]) REFERENCES [dbo].[Pedido_Venda] ([cd_pedido_venda]),
    CONSTRAINT [FK_Calculo_Comissao_Pedido_Venda_Item] FOREIGN KEY ([cd_pedido_venda], [cd_item_pedido_venda]) REFERENCES [dbo].[Pedido_Venda_Item] ([cd_pedido_venda], [cd_item_pedido_venda]),
    CONSTRAINT [FK_Calculo_Comissao_Tipo_Comissao] FOREIGN KEY ([cd_tipo_comissao]) REFERENCES [dbo].[Tipo_Comissao] ([cd_tipo_comissao]),
    CONSTRAINT [FK_Calculo_Comissao_Vendedor] FOREIGN KEY ([cd_vendedor]) REFERENCES [dbo].[Vendedor] ([cd_vendedor])
);

