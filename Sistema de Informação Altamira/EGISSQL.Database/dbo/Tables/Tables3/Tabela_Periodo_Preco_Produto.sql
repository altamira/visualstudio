CREATE TABLE [dbo].[Tabela_Periodo_Preco_Produto] (
    [cd_tabela_periodo]          INT          NOT NULL,
    [dt_inicio_tabela]           DATETIME     NULL,
    [dt_final_tabela]            DATETIME     NULL,
    [cd_tabela_preco]            INT          NOT NULL,
    [cd_produto]                 INT          NOT NULL,
    [vl_tabela_produto]          FLOAT (53)   NULL,
    [cd_moeda]                   INT          NULL,
    [cd_aplicacao_markup]        INT          NULL,
    [vl_custo_tabela_produto]    FLOAT (53)   NULL,
    [nm_obs_tabela_produto]      VARCHAR (40) NULL,
    [qt_tabela_produto]          FLOAT (53)   NULL,
    [cd_unidade_medida]          INT          NULL,
    [pc_comissao_tabela_produto] FLOAT (53)   NULL,
    [cd_condicao_pagamento]      INT          NULL,
    [cd_unidade_unidade]         INT          NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [cd_interface]               INT          NULL,
    CONSTRAINT [PK_Tabela_Periodo_Preco_Produto] PRIMARY KEY CLUSTERED ([cd_tabela_periodo] ASC, [cd_tabela_preco] ASC, [cd_produto] ASC),
    CONSTRAINT [FK_Tabela_Periodo_Preco_Produto_Unidade_Medida] FOREIGN KEY ([cd_unidade_unidade]) REFERENCES [dbo].[Unidade_Medida] ([cd_unidade_medida])
);

