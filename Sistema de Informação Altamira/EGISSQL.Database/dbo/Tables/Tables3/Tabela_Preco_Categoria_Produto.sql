CREATE TABLE [dbo].[Tabela_Preco_Categoria_Produto] (
    [cd_tabela_preco]        INT          NOT NULL,
    [cd_categoria_produto]   INT          NOT NULL,
    [vl_tabela_preco]        FLOAT (53)   NULL,
    [vl_base_icms_subs_trib] FLOAT (53)   NULL,
    [nm_obs_tabela_preco]    VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Tabela_Preco_Categoria_Produto] PRIMARY KEY CLUSTERED ([cd_tabela_preco] ASC, [cd_categoria_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tabela_Preco_Categoria_Produto_Categoria_Produto] FOREIGN KEY ([cd_categoria_produto]) REFERENCES [dbo].[Categoria_Produto] ([cd_categoria_produto])
);

