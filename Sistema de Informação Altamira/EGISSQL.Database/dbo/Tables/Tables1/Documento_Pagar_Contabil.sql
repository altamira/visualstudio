CREATE TABLE [dbo].[Documento_Pagar_Contabil] (
    [cd_documento_pagar]        INT          NULL,
    [cd_item_contab_documento]  INT          NULL,
    [dt_contab_documento]       DATETIME     NULL,
    [cd_lancamento_padrao]      INT          NULL,
    [cd_conta_credito]          INT          NULL,
    [cd_conta_debito]           INT          NULL,
    [vl_contab_documento]       FLOAT (53)   NULL,
    [cd_historico_contabil]     INT          NULL,
    [nm_historico_documento]    VARCHAR (40) NULL,
    [ic_sct_contab_documento]   CHAR (1)     NULL,
    [dt_sct_contab_documento]   DATETIME     NULL,
    [cd_lote_contabil]          INT          NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_item_pagamento]         INT          NULL,
    [cd_reduzido_conta_debito]  INT          NULL,
    [cd_reduzido_conta_credito] INT          NULL
);

