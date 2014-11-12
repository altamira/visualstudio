CREATE TABLE [dbo].[Fornecedor_Servico] (
    [cd_fornecedor]             INT          NOT NULL,
    [cd_servico]                INT          NOT NULL,
    [ic_cotacao_fornecedor]     CHAR (1)     NULL,
    [nm_referencia_fornecedor]  VARCHAR (30) NULL,
    [dt_cotacao_fornecedor]     DATETIME     NULL,
    [dt_pedido_fornecedor]      DATETIME     NULL,
    [qt_dia_entrega_fornecedor] INT          NULL,
    [ds_observacao_servico]     TEXT         NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_unidade_medida]         INT          NULL,
    [cd_condicao_pagamento]     INT          NULL,
    [nm_servico_fornecedor]     VARCHAR (40) NULL,
    [ds_servico_fornecedor]     TEXT         NULL,
    [qt_minimo_fornecedor]      FLOAT (53)   NULL,
    [cd_opcao_compra]           INT          NULL,
    [cd_moeda]                  INT          NULL,
    [qt_dia_compra_fornecedor]  FLOAT (53)   NULL,
    CONSTRAINT [PK_Fornecedor_Servico] PRIMARY KEY CLUSTERED ([cd_fornecedor] ASC, [cd_servico] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Fornecedor_Servico_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda])
);

