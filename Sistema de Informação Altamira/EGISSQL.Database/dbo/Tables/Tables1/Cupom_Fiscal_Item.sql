CREATE TABLE [dbo].[Cupom_Fiscal_Item] (
    [cd_cupom_fiscal]         INT          NOT NULL,
    [cd_item_cupom_fiscal]    INT          NOT NULL,
    [cd_produto]              INT          NULL,
    [nm_produto_cupom_fiscal] VARCHAR (40) NULL,
    [qt_item_cupom_fiscal]    FLOAT (53)   NULL,
    [vl_item_cupom_fiscal]    FLOAT (53)   NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Cupom_Fiscal_Item] PRIMARY KEY CLUSTERED ([cd_cupom_fiscal] ASC, [cd_item_cupom_fiscal] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cupom_Fiscal_Item_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

