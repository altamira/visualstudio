CREATE TABLE [dbo].[Autorizacao_Pagamento] (
    [cd_ap]                   INT        NOT NULL,
    [dt_ap]                   DATETIME   NULL,
    [ds_ap]                   TEXT       NULL,
    [dt_aprovacao_ap]         DATETIME   NULL,
    [vl_ap]                   FLOAT (53) NULL,
    [cd_usuario]              INT        NULL,
    [dt_usuario]              DATETIME   NULL,
    [cd_usuario_aprovacao]    INT        NULL,
    [cd_tipo_ap]              INT        NULL,
    [cd_cheque_pagar]         INT        NULL,
    [cd_requisicao_viagem]    INT        NULL,
    [cd_solicitacao]          INT        NULL,
    [cd_funcionario]          INT        NULL,
    [cd_fornecedor]           INT        NULL,
    [cd_documento_pagar]      INT        NULL,
    [cd_prestacao]            INT        NULL,
    [cd_item_adto_fornecedor] INT        NULL,
    [dt_pagamento_ap]         DATETIME   NULL,
    [cd_controle_folha]       INT        NULL,
    CONSTRAINT [PK_Autorizacao_Pagamento] PRIMARY KEY CLUSTERED ([cd_ap] ASC) WITH (FILLFACTOR = 90)
);

