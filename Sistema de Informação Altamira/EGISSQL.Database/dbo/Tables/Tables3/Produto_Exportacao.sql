CREATE TABLE [dbo].[Produto_Exportacao] (
    [cd_produto]               INT      NOT NULL,
    [cd_categoria_produto]     INT      NULL,
    [cd_usuario]               INT      NULL,
    [dt_usuario]               DATETIME NULL,
    [cd_fabricante]            INT      NULL,
    [cd_idioma_documento_prod] INT      NULL,
    [ds_produto_exportacao]    TEXT     NULL,
    CONSTRAINT [PK_Produto_Exportacao] PRIMARY KEY CLUSTERED ([cd_produto] ASC) WITH (FILLFACTOR = 90)
);

