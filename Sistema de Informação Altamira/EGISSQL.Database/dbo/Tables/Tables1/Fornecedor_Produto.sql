﻿CREATE TABLE [dbo].[Fornecedor_Produto] (
    [cd_fornecedor]             INT          NOT NULL,
    [cd_produto]                INT          NOT NULL,
    [ic_cotacao_fornecedor]     CHAR (1)     NULL,
    [nm_referencia_fornecedor]  VARCHAR (30) NULL,
    [nm_marca_fornecedor]       VARCHAR (30) NULL,
    [dt_cotacao_fornecedor]     DATETIME     NULL,
    [dt_pedido_fornecedor]      DATETIME     NULL,
    [nm_condicao_pagamento]     VARCHAR (30) NULL,
    [qt_dia_entrega_fornecedor] INT          NULL,
    [ds_observacao_produto]     TEXT         NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_unidade_medida]         INT          NULL,
    [cd_condicao_pagamento]     INT          NULL,
    [nm_produto_fornecedor]     VARCHAR (40) NULL,
    [ds_produto_fornecedor]     TEXT         NULL,
    [qt_minimo_fornecedor]      FLOAT (53)   NULL,
    [cd_opcao_compra]           INT          NULL,
    [cd_moeda]                  INT          NULL,
    [qt_dia_compra_fornecedor]  FLOAT (53)   NULL,
    [qt_nota_prod_fornecedor]   FLOAT (53)   NULL,
    CONSTRAINT [PK_Fornecedor_Produto] PRIMARY KEY CLUSTERED ([cd_fornecedor] ASC, [cd_produto] ASC) WITH (FILLFACTOR = 90)
);

