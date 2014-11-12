CREATE TABLE [dbo].[Cobranca_Cemiterio] (
    [cd_cobranca]           INT          NOT NULL,
    [cd_tipo_parcela]       INT          NULL,
    [cd_status_parcela]     INT          NULL,
    [cd_documento]          VARCHAR (25) NULL,
    [cd_cliente]            INT          NULL,
    [cd_contrato]           INT          NULL,
    [dt_vencimento]         DATETIME     NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [vl_cobranca_cemiterio] FLOAT (53)   NULL,
    [dt_pagamento]          DATETIME     NULL,
    [cd_produto]            INT          NULL,
    [cd_documento_receber]  INT          NULL,
    CONSTRAINT [PK_Cobranca_Cemiterio] PRIMARY KEY CLUSTERED ([cd_cobranca] ASC) WITH (FILLFACTOR = 90)
);

