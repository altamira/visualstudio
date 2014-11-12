CREATE TABLE [dbo].[Comissao] (
    [cd_comissao]          INT        NOT NULL,
    [cd_vendedor]          INT        NULL,
    [cd_vendedor_interno]  INT        NULL,
    [dt_base_comissao]     DATETIME   NULL,
    [cd_tipo_comissao]     INT        NULL,
    [cd_cliente]           INT        NULL,
    [cd_pedido_venda]      INT        NULL,
    [cd_item_pedido_venda] INT        NULL,
    [qt_item_pedido_venda] FLOAT (53) NULL,
    [vl_total]             FLOAT (53) NULL,
    [pc_comissao]          FLOAT (53) NULL,
    [vl_comissao]          FLOAT (53) NULL,
    [cd_nota_saida]        INT        NULL,
    [cd_item_nota_saida]   INT        NULL,
    [cd_categoria_produto] INT        NULL,
    [cd_usuario]           INT        NULL,
    [dt_usuario]           DATETIME   NULL,
    CONSTRAINT [PK_Comissao] PRIMARY KEY CLUSTERED ([cd_comissao] ASC) WITH (FILLFACTOR = 90)
);

