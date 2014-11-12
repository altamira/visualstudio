﻿CREATE TABLE [dbo].[Pedido_Venda_Composicao] (
    [cd_pedido_venda]          INT          NOT NULL,
    [cd_item_pedido_venda]     INT          NOT NULL,
    [cd_produto]               INT          NULL,
    [cd_id_item_pedido_venda]  INT          NOT NULL,
    [qt_item_produto_comp]     FLOAT (53)   NULL,
    [cd_fase_produto]          INT          NULL,
    [ic_estoque_produto]       CHAR (1)     NULL,
    [dt_estoque_produto]       DATETIME     NULL,
    [ic_reserva_estoque_prod]  CHAR (1)     NULL,
    [dt_reserva_estoque_prod]  DATETIME     NULL,
    [qt_peso_liquido_produto]  FLOAT (53)   NULL,
    [qt_peso_bruto_produto]    FLOAT (53)   NULL,
    [nm_obs_ordem_montagem]    VARCHAR (40) NULL,
    [ic_calculo_peso_produto]  CHAR (1)     NULL,
    [pc_composicao_produto]    FLOAT (53)   NULL,
    [ic_montagemg_produto]     CHAR (1)     NULL,
    [ic_tipo_montagem_produto] CHAR (1)     NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_ordem_item_composicao] INT          NULL,
    [nm_produto_composicao]    VARCHAR (15) NULL,
    [cd_cor]                   INT          NULL,
    [nm_fantasia_produto]      VARCHAR (30) NULL,
    [vl_item_comp_pedido]      FLOAT (53)   NULL,
    [cd_versao_produto]        INT          NULL,
    [cd_implantacao]           INT          NULL,
    CONSTRAINT [PK_Pedido_Venda_Composicao] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC, [cd_item_pedido_venda] ASC, [cd_id_item_pedido_venda] ASC) WITH (FILLFACTOR = 90)
);

