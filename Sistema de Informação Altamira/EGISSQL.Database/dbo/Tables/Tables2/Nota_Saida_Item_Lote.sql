CREATE TABLE [dbo].[Nota_Saida_Item_Lote] (
    [cd_nota_saida_item_lote] INT          NOT NULL,
    [cd_nota_saida]           INT          NOT NULL,
    [cd_item_nota_saida]      INT          NOT NULL,
    [cd_produto]              INT          NULL,
    [nm_lote]                 VARCHAR (25) NOT NULL,
    [cd_laudo]                INT          NULL,
    [ic_impresso]             CHAR (1)     NULL,
    [cd_lote_produto]         INT          NULL,
    [cd_chave]                INT          NULL,
    CONSTRAINT [PK_Nota_Saida_Item_Lote] PRIMARY KEY CLUSTERED ([cd_nota_saida_item_lote] ASC, [cd_nota_saida] ASC, [cd_item_nota_saida] ASC, [nm_lote] ASC) WITH (FILLFACTOR = 90)
);

