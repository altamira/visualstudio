CREATE TABLE [dbo].[Mapa_Categoria_Produto] (
    [cd_tipo_mapa_categoria]    INT          NOT NULL,
    [cd_grupo_categoria]        INT          NOT NULL,
    [cd_categoria_produto]      INT          NOT NULL,
    [cd_grupo_categoria_mapa]   INT          NOT NULL,
    [cd_cor_relatorio_categ]    VARCHAR (15) NULL,
    [cd_categoria_produto_mapa] INT          NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Mapa_Categoria_Produto] PRIMARY KEY CLUSTERED ([cd_tipo_mapa_categoria] ASC, [cd_grupo_categoria] ASC, [cd_categoria_produto] ASC, [cd_grupo_categoria_mapa] ASC) WITH (FILLFACTOR = 90)
);

