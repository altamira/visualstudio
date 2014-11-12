CREATE TABLE [dbo].[PedidoWap] (
    [cd_pedidoWap]          INT        NOT NULL,
    [dt_pedidoWap]          DATETIME   NOT NULL,
    [cd_vendedor]           INT        NOT NULL,
    [cd_tipo_varejo]        INT        NOT NULL,
    [cd_condicao_pagamento] INT        NOT NULL,
    [cd_fornecedor]         INT        NOT NULL,
    [vl_pedidoWap]          FLOAT (53) NULL,
    [cd_usuario]            INT        NULL,
    [dt_usuario]            DATETIME   NULL,
    CONSTRAINT [PK_PedidoWap] PRIMARY KEY CLUSTERED ([cd_pedidoWap] ASC) WITH (FILLFACTOR = 90)
);

