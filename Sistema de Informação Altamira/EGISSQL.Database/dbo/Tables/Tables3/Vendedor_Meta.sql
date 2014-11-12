CREATE TABLE [dbo].[Vendedor_Meta] (
    [cd_vendedor]               INT          NOT NULL,
    [cd_categoria_produto]      INT          NOT NULL,
    [dt_inicio_meta_vendedor]   DATETIME     NULL,
    [dt_final_meta_vendedor]    DATETIME     NULL,
    [vl_meta_vendedor]          FLOAT (53)   NULL,
    [vl_consulta_meta_vendedor] FLOAT (53)   NULL,
    [vl_pedido_meta_vendedor]   FLOAT (53)   NULL,
    [vl_faturado_meta_vendedor] FLOAT (53)   NULL,
    [nm_obs_meta_vendedor]      VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [pc_meta_vendedor]          FLOAT (53)   NULL,
    [qt_meta_vendedor]          FLOAT (53)   NULL,
    [cd_vendedor_meta]          INT          NOT NULL,
    CONSTRAINT [PK_Vendedor_Meta] PRIMARY KEY CLUSTERED ([cd_vendedor] ASC, [cd_categoria_produto] ASC, [cd_vendedor_meta] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Vendedor_Meta_Categoria_Produto] FOREIGN KEY ([cd_categoria_produto]) REFERENCES [dbo].[Categoria_Produto] ([cd_categoria_produto])
);

