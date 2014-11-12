CREATE TABLE [dbo].[Produto_Contrato] (
    [cd_contrato]              INT        NOT NULL,
    [cd_item_produto_contrato] INT        NOT NULL,
    [cd_produto]               INT        NULL,
    [dt_venda_produto]         DATETIME   NOT NULL,
    [cd_vendedor]              INT        NULL,
    [cd_cobrador]              INT        NULL,
    [vl_produto]               FLOAT (53) NULL,
    [vl_entrada_produto]       FLOAT (53) NULL,
    [ds_obs_produto]           TEXT       NULL,
    [cd_condicao_pagamento]    INT        NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    [qt_parcela_produto]       INT        NULL,
    CONSTRAINT [PK_Produto_Contrato] PRIMARY KEY CLUSTERED ([cd_contrato] ASC, [cd_item_produto_contrato] ASC) WITH (FILLFACTOR = 90)
);

