CREATE TABLE [dbo].[Produto_Servico_Especial] (
    [cd_produto_servico]       INT          NOT NULL,
    [cd_produto]               INT          NOT NULL,
    [cd_servico_especial]      INT          NOT NULL,
    [cd_fornecedor]            INT          NULL,
    [vl_custo_produto_servico] FLOAT (53)   NULL,
    [nm_obs_produto_servico]   VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Produto_Servico_Especial] PRIMARY KEY CLUSTERED ([cd_produto_servico] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Servico_Especial_Fornecedor] FOREIGN KEY ([cd_fornecedor]) REFERENCES [dbo].[Fornecedor] ([cd_fornecedor])
);

