CREATE TABLE [dbo].[Nota_Saida_Retorno] (
    [cd_nota_saida]        INT          NULL,
    [ITEM]                 INT          NULL,
    [NF]                   INT          NULL,
    [DATA]                 DATETIME     NULL,
    [cd_produto]           INT          NULL,
    [cd_mascara_produto]   VARCHAR (20) NULL,
    [nm_fantasia_produto]  VARCHAR (25) NULL,
    [qt_movimento_entrada] FLOAT (53)   NULL,
    [qt_movimento_saida]   FLOAT (53)   NULL,
    [qt_movimento_parcial] FLOAT (53)   NULL,
    [vl_item_nota_entrada] FLOAT (53)   NULL,
    [VALOR]                FLOAT (53)   NULL,
    [SALDO]                VARCHAR (25) NULL
);

