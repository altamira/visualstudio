CREATE TABLE [dbo].[Embarque_Importacao_Item] (
    [cd_embarque]               INT          NOT NULL,
    [cd_embarque_item]          INT          NOT NULL,
    [cd_pedido_importacao]      INT          NOT NULL,
    [cd_item_ped_imp]           INT          NOT NULL,
    [vl_produto_embarque]       FLOAT (53)   NULL,
    [qt_produto_embarque]       FLOAT (53)   NULL,
    [qt_peso_liquido_embarque]  FLOAT (53)   NULL,
    [qt_peso_bruto_embarque]    FLOAT (53)   NULL,
    [dt_producao_item_embarque] DATETIME     NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_validade_item_embarque] DATETIME     NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_lote_item_embarque]     VARCHAR (25) NULL,
    [nm_obs_item_embarque]      VARCHAR (40) NULL,
    CONSTRAINT [PK_Embarque_Importacao_Item] PRIMARY KEY CLUSTERED ([cd_embarque] ASC, [cd_embarque_item] ASC, [cd_pedido_importacao] ASC) WITH (FILLFACTOR = 90)
);

