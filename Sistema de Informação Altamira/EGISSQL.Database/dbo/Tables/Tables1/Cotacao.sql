CREATE TABLE [dbo].[Cotacao] (
    [cd_cotacao]               INT      NOT NULL,
    [dt_cotacao]               DATETIME NULL,
    [cd_fornecedor]            INT      NULL,
    [cd_contato_fornecedor]    INT      NULL,
    [ds_cotacao]               TEXT     NULL,
    [ic_lista_cotacao]         CHAR (1) NULL,
    [dt_fechamento_cotacao]    DATETIME NULL,
    [ic_pedido_compra_cotacao] CHAR (1) NULL,
    [cd_usuario]               INT      NULL,
    [dt_usuario]               DATETIME NULL,
    [ic_listado_cotacao]       CHAR (1) NULL,
    [cd_moeda]                 INT      NULL,
    [cd_tipo_envio]            INT      NULL,
    [ic_maquina]               CHAR (1) NULL,
    [cd_aplicacao_produto]     INT      NULL,
    [cd_condicao_pagamento]    INT      NULL,
    [cd_destinacao_produto]    INT      NULL,
    [cd_comprador]             INT      NULL,
    [ic_retorno_fornecedor]    CHAR (1) NULL,
    [dt_retorno_fornecedor]    DATETIME NULL,
    [cd_opcao_compra]          INT      NULL,
    CONSTRAINT [PK_Cotacao] PRIMARY KEY CLUSTERED ([cd_cotacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cotacao_Opcao_Compra] FOREIGN KEY ([cd_opcao_compra]) REFERENCES [dbo].[Opcao_Compra] ([cd_opcao_compra])
);


GO
CREATE NONCLUSTERED INDEX [ix_dt_cotacao]
    ON [dbo].[Cotacao]([dt_cotacao] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Cotacao_Consulta]
    ON [dbo].[Cotacao]([cd_cotacao] ASC, [dt_cotacao] ASC, [cd_fornecedor] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Cotacao_Consulta_Data]
    ON [dbo].[Cotacao]([dt_cotacao] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Cotacao_consulta_fornecedor]
    ON [dbo].[Cotacao]([cd_fornecedor] ASC) WITH (FILLFACTOR = 90);

