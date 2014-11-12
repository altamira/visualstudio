CREATE TABLE [dbo].[Registro_Venda_Item] (
    [cd_registro_venda]      INT        NOT NULL,
    [cd_item_registro_venda] INT        NOT NULL,
    [cd_produto]             INT        NULL,
    [qt_item_registro_venda] FLOAT (53) NULL,
    [cd_usuario]             INT        NULL,
    [dt_usuario]             DATETIME   NULL,
    [vl_produto]             FLOAT (53) NULL,
    [pc_icms_produto]        FLOAT (53) NULL,
    CONSTRAINT [PK_Registro_Venda_Item] PRIMARY KEY CLUSTERED ([cd_registro_venda] ASC, [cd_item_registro_venda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Registro_Venda_Item_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

