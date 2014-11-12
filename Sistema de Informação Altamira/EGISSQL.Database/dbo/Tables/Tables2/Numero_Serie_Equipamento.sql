CREATE TABLE [dbo].[Numero_Serie_Equipamento] (
    [dt_usuario]                DATETIME     NULL,
    [cd_usuario]                INT          NULL,
    [dt_vencto_equipto_serie]   DATETIME     NULL,
    [ic_garantia_equipto_serie] CHAR (1)     NULL,
    [cd_nota_entrada]           INT          NULL,
    [cd_nota_saida]             INT          NULL,
    [cd_produto]                INT          NULL,
    [cd_cliente]                INT          NULL,
    [cd_equipamento_serie]      INT          NOT NULL,
    [aa_equipamento_serie]      INT          NULL,
    [cd_numero_equipto_serie]   VARCHAR (30) NULL,
    [cd_pedido_venda]           INT          NULL,
    [cd_item_pedido_venda]      INT          NULL,
    [nm_produto_cliente]        VARCHAR (60) NULL,
    [cd_fornecedor]             INT          NULL,
    [cd_serie_nota_fiscal]      INT          NULL,
    [cd_operacao_fiscal]        INT          NULL,
    CONSTRAINT [PK_Numero_Serie_Equipamento] PRIMARY KEY CLUSTERED ([cd_equipamento_serie] ASC) WITH (FILLFACTOR = 90)
);

