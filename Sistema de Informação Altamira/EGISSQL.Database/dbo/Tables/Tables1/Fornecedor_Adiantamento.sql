CREATE TABLE [dbo].[Fornecedor_Adiantamento] (
    [cd_fornecedor]            INT          NOT NULL,
    [cd_item_adto_fornecedor]  INT          NOT NULL,
    [dt_adto_fornecedor]       DATETIME     NULL,
    [vl_adto_fornecedor]       FLOAT (53)   NULL,
    [dt_baixa_adto_fornecedor] DATETIME     NULL,
    [nm_obs_adto_fornecedor]   VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_documento_pagar]       INT          NULL,
    [cd_pedido_compra]         INT          NULL,
    [cd_ap]                    INT          NULL,
    [cd_lancamento]            INT          NULL,
    [cd_lancamento_caixa]      INT          NULL,
    [cd_plano_financeiro]      INT          NULL,
    [cd_conta_banco]           INT          NULL,
    [cd_tipo_caixa]            INT          NULL,
    CONSTRAINT [PK_Fornecedor_Adiantamento] PRIMARY KEY CLUSTERED ([cd_fornecedor] ASC, [cd_item_adto_fornecedor] ASC) WITH (FILLFACTOR = 90)
);

