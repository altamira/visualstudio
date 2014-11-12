CREATE TABLE [dbo].[Parcela] (
    [cd_parcela]            INT          NOT NULL,
    [cd_contrato]           INT          NOT NULL,
    [cd_produto]            INT          NOT NULL,
    [cd_num_parcela]        INT          NULL,
    [dt_vencimento_parcela] DATETIME     NULL,
    [vl_parcela]            FLOAT (53)   NULL,
    [dt_pagamento_parcela]  DATETIME     NULL,
    [vl_pago_parcela]       FLOAT (53)   NULL,
    [cd_banco]              INT          NULL,
    [cd_agencia_banco]      INT          NULL,
    [cd_tipo_parcela]       INT          NULL,
    [ds_obs_parcela]        TEXT         NULL,
    [cd_doc_parcela]        VARCHAR (30) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Parcela] PRIMARY KEY CLUSTERED ([cd_parcela] ASC, [cd_contrato] ASC, [cd_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parcela_Banco] FOREIGN KEY ([cd_banco]) REFERENCES [dbo].[Banco] ([cd_banco]),
    CONSTRAINT [FK_Parcela_Tipo_Parcela] FOREIGN KEY ([cd_tipo_parcela]) REFERENCES [dbo].[Tipo_Parcela] ([cd_tipo_parcela])
);

