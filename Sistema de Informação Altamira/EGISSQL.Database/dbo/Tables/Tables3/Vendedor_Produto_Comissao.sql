CREATE TABLE [dbo].[Vendedor_Produto_Comissao] (
    [cd_vendedor]               INT          NOT NULL,
    [cd_categoria_produto]      INT          NOT NULL,
    [pc_comissao_prod_vendedor] FLOAT (53)   NULL,
    [nm_obscomis_prod_vendedor] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Vendedor_Produto_Comissao] PRIMARY KEY CLUSTERED ([cd_vendedor] ASC, [cd_categoria_produto] ASC) WITH (FILLFACTOR = 90)
);

