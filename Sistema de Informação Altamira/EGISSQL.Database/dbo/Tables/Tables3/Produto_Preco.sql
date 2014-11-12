CREATE TABLE [dbo].[Produto_Preco] (
    [cd_produto]              INT          NOT NULL,
    [dt_produto_preco]        DATETIME     NOT NULL,
    [vl_atual_produto_preco]  FLOAT (53)   NOT NULL,
    [vl_temp_produto_preco]   FLOAT (53)   NOT NULL,
    [qt_indice_produto_preco] FLOAT (53)   NULL,
    [nm_obs_produto_preco]    VARCHAR (40) NULL,
    [cd_grupo_preco_produto]  INT          NULL,
    [cd_moeda]                INT          NULL,
    [cd_tipo_reajuste]        INT          NULL,
    [cd_motivo_reajuste]      INT          NULL,
    [cd_tipo_tabela_preco]    INT          NULL,
    [cd_usuario]              INT          NOT NULL,
    [dt_usuario]              DATETIME     NOT NULL,
    [cd_cliente]              INT          NULL,
    [cd_servico]              INT          NULL,
    CONSTRAINT [PK_Produto_Preco] PRIMARY KEY CLUSTERED ([cd_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Preco_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente])
);

