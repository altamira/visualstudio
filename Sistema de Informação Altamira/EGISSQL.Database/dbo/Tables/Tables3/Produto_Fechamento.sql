CREATE TABLE [dbo].[Produto_Fechamento] (
    [cd_produto]                INT        NOT NULL,
    [cd_fase_produto]           INT        NOT NULL,
    [dt_produto_fechamento]     DATETIME   NOT NULL,
    [qt_atual_prod_fechamento]  FLOAT (53) NULL,
    [qt_entra_prod_fechamento]  FLOAT (53) NULL,
    [qt_saida_prod_fechamento]  FLOAT (53) NULL,
    [qt_consig_prod_fechamento] FLOAT (53) NULL,
    [qt_terc_prod_fechamento]   FLOAT (53) NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    [vl_custo_prod_fechamento]  FLOAT (53) NULL,
    [vl_maior_lista_produto]    FLOAT (53) NULL,
    [vl_maior_preco_produto]    FLOAT (53) NULL,
    [vl_maior_custo_produto]    FLOAT (53) NULL,
    [vl_custo_ueps_fechamento]  FLOAT (53) NULL,
    [vl_custo_peps_fechamento]  FLOAT (53) NULL,
    [vl_custo_medio_fechamento] FLOAT (53) NULL,
    [ic_peps_produto]           CHAR (1)   NULL,
    [qt_peps_prod_fechamento]   FLOAT (53) NULL,
    [qt_ueps_prod_fechamento]   FLOAT (53) NULL,
    [ic_terc_prod_fechamento]   CHAR (1)   NULL,
    [ic_consig_prod_fechamento] CHAR (1)   NULL,
    [qt_medio_prod_fechamento]  FLOAT (53) NULL,
    [qt_peso_prod_fechamento]   FLOAT (53) NULL,
    [qt_peso_terc_fechamento]   FLOAT (53) NULL,
    [cd_metodo_valoracao]       INT        NULL,
    [vl_custo_entrada]          FLOAT (53) NULL,
    [vl_custo_saida]            FLOAT (53) NULL,
    [qt_peso_entra_fechamento]  FLOAT (53) NULL,
    [qt_peso_saida_fechamento]  FLOAT (53) NULL,
    [vl_unitario_custo]         FLOAT (53) NULL,
    CONSTRAINT [PK_Produto_Fechamento] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_fase_produto] ASC, [dt_produto_fechamento] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_Produto_Fechamento_dt_produto_fechamento]
    ON [dbo].[Produto_Fechamento]([dt_produto_fechamento] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Saldo_Atual_Produto_Fechamento]
    ON [dbo].[Produto_Fechamento]([cd_produto] ASC, [qt_atual_prod_fechamento] ASC) WITH (FILLFACTOR = 90);

