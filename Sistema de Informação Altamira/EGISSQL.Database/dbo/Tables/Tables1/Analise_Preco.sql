CREATE TABLE [dbo].[Analise_Preco] (
    [cd_produto]                 INT        NOT NULL,
    [qt_saldo_atual_produto]     FLOAT (53) NULL,
    [vl_preco_fob_produto]       FLOAT (53) NULL,
    [vl_custo_reposicao_produto] FLOAT (53) NULL,
    [vl_custo_real_produto]      FLOAT (53) NULL,
    [vl_bnp_produto]             FLOAT (53) NULL,
    [vl_venda_produto]           FLOAT (53) NULL,
    [vl_margem_produto]          FLOAT (53) NULL,
    [vl_fator_produto]           FLOAT (53) NULL,
    [vl_margem_ideal_produto]    FLOAT (53) NULL,
    [vl_venda_ideal_produto]     FLOAT (53) NULL,
    [vl_mercado_produto]         FLOAT (53) NULL,
    [pc_desconto_produto]        FLOAT (53) NULL,
    [vl_desconto_produto]        FLOAT (53) NULL,
    [vl_margem_estimada]         FLOAT (53) NULL,
    [vl_margem_real]             FLOAT (53) NULL,
    [cd_usuario]                 INT        NULL,
    [dt_usuario]                 DATETIME   NULL,
    CONSTRAINT [PK_Analise_Preco] PRIMARY KEY CLUSTERED ([cd_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Analise_Preco_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

