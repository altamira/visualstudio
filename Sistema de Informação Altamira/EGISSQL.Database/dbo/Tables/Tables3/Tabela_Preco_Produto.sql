CREATE TABLE [dbo].[Tabela_Preco_Produto] (
    [cd_tabela_preco]            INT          NOT NULL,
    [cd_produto]                 INT          NOT NULL,
    [vl_tabela_produto]          FLOAT (53)   NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [nm_obs_tabela_produto]      VARCHAR (40) NULL,
    [cd_aplicacao_markup]        INT          NULL,
    [vl_custo_tabela_produto]    FLOAT (53)   NULL,
    [cd_moeda]                   INT          NULL,
    [qt_tabela_produto]          FLOAT (53)   NULL,
    [cd_unidade_medida]          INT          NULL,
    [pc_comissao_tabela_produto] FLOAT (53)   NULL,
    [cd_condicao_pagamento]      INT          NULL,
    [cd_unidade_unidade]         INT          NULL,
    CONSTRAINT [PK_Tabela_Preco_Produto] PRIMARY KEY CLUSTERED ([cd_tabela_preco] ASC, [cd_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tabela_Preco_Produto_Aplicacao_Markup] FOREIGN KEY ([cd_aplicacao_markup]) REFERENCES [dbo].[Aplicacao_Markup] ([cd_aplicacao_markup]),
    CONSTRAINT [FK_Tabela_Preco_Produto_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda]),
    CONSTRAINT [FK_Tabela_Preco_Produto_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto]),
    CONSTRAINT [FK_Tabela_Preco_Produto_Unidade_Medida] FOREIGN KEY ([cd_unidade_medida]) REFERENCES [dbo].[Unidade_Medida] ([cd_unidade_medida])
);

