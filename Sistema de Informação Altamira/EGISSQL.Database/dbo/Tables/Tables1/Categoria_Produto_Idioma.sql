CREATE TABLE [dbo].[Categoria_Produto_Idioma] (
    [cd_categoria_produto]     INT          NOT NULL,
    [cd_idioma]                INT          NOT NULL,
    [nm_categoria_prod_idioma] VARCHAR (60) NULL,
    [cd_usuario]               INT          NOT NULL,
    [dt_usuario]               DATETIME     NOT NULL,
    CONSTRAINT [PK_Categoria_Produto_Idioma] PRIMARY KEY CLUSTERED ([cd_categoria_produto] ASC, [cd_idioma] ASC) WITH (FILLFACTOR = 90)
);

