﻿CREATE TABLE [dbo].[Programacao_Entrega] (
    [cd_programacao_entrega]       INT          NOT NULL,
    [dt_programacao_entrega]       DATETIME     NULL,
    [dt_necessidade_entrega]       DATETIME     NULL,
    [cd_produto]                   INT          NULL,
    [cd_cliente]                   INT          NULL,
    [qt_programacao_entrega]       FLOAT (53)   NULL,
    [nm_obs_programacao_entrega]   VARCHAR (40) NULL,
    [cd_contrato_fornecimento]     INT          NULL,
    [cd_ano]                       INT          NULL,
    [cd_mes]                       INT          NULL,
    [cd_usuario]                   INT          NULL,
    [dt_usuario]                   DATETIME     NULL,
    [cd_identificacao_programacao] VARCHAR (25) NULL,
    [cd_tipo_programacao]          INT          NULL,
    [cd_lote_programacao]          VARCHAR (25) NULL,
    [cd_pedido_compra_programacao] VARCHAR (30) NULL,
    [qt_total_produto_programacao] FLOAT (53)   NULL,
    [qt_total_itens_programacao]   FLOAT (53)   NULL,
    [cd_movimento_estoque]         INT          NULL,
    [cd_pedido_venda]              INT          NULL,
    [cd_item_pedido_venda]         INT          NULL,
    [cd_processo]                  INT          NULL,
    [ic_selecao_programacao]       CHAR (1)     NULL,
    [cd_requisicao_interna]        INT          NULL,
    [cd_requisicao_compra]         INT          NULL,
    [dt_baixa_programacao]         DATETIME     NULL,
    [cd_usuario_baixa_programacao] INT          NULL,
    [cd_previa_faturamento]        INT          NULL,
    [qt_saldo_programacao]         FLOAT (53)   NULL,
    [qt_remessa_programacao]       FLOAT (53)   NULL,
    [qt_selecao_programacao]       FLOAT (53)   NULL,
    [dt_cancelamento_programacao]  DATETIME     NULL,
    [qt_cancelamento_programacao]  FLOAT (53)   NULL,
    CONSTRAINT [PK_Programacao_Entrega] PRIMARY KEY CLUSTERED ([cd_programacao_entrega] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Programacao_Entrega_Tipo_Programacao] FOREIGN KEY ([cd_tipo_programacao]) REFERENCES [dbo].[Tipo_Programacao] ([cd_tipo_programacao])
);

