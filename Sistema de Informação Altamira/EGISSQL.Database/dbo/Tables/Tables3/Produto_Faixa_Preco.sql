CREATE TABLE [dbo].[Produto_Faixa_Preco] (
    [cd_produto]              INT          NOT NULL,
    [cd_tipo_faixa_preco]     INT          NOT NULL,
    [vl_minimo_produto]       FLOAT (53)   NULL,
    [vl_maximo_produto]       FLOAT (53)   NULL,
    [nm_obs_preco_produto]    VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [pc_desconto_faixa_preco] FLOAT (53)   NULL,
    [cd_moeda]                INT          NULL,
    CONSTRAINT [PK_Produto_Faixa_Preco] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_tipo_faixa_preco] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Faixa_Preco_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda]),
    CONSTRAINT [FK_Produto_Faixa_Preco_Tipo_Faixa_Preco_Produto] FOREIGN KEY ([cd_tipo_faixa_preco]) REFERENCES [dbo].[Tipo_Faixa_Preco_Produto] ([cd_tipo_faixa_preco])
);

