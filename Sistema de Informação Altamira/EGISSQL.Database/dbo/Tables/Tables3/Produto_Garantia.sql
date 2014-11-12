CREATE TABLE [dbo].[Produto_Garantia] (
    [cd_produto]          INT      NOT NULL,
    [ds_produto_garantia] TEXT     NULL,
    [cd_usuario]          INT      NULL,
    [dt_usuario]          DATETIME NULL,
    [cd_termo_garantia]   INT      NULL,
    CONSTRAINT [PK_Produto_Garantia] PRIMARY KEY CLUSTERED ([cd_produto] ASC) WITH (FILLFACTOR = 90)
);

