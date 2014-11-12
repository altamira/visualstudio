CREATE TABLE [dbo].[Plano_MRP_Composicao] (
    [cd_plano_mrp]          INT        NOT NULL,
    [cd_item_plano_mrp]     INT        NOT NULL,
    [cd_produto]            INT        NULL,
    [cd_fase_produto]       INT        NULL,
    [qt_plano_mrp]          FLOAT (53) NULL,
    [cd_usuario]            INT        NULL,
    [dt_usuario]            DATETIME   NULL,
    [cd_pedido_venda]       INT        NULL,
    [cd_item_pedido_venda]  INT        NULL,
    [cd_requisicao_compra]  INT        NULL,
    [cd_requisicao_interna] INT        NULL,
    [cd_processo]           INT        NULL,
    [cd_previsao_venda]     INT        NULL,
    CONSTRAINT [PK_Plano_MRP_Composicao] PRIMARY KEY CLUSTERED ([cd_plano_mrp] ASC, [cd_item_plano_mrp] ASC) WITH (FILLFACTOR = 90)
);

