CREATE TABLE [dbo].[Produto_Orcamento] (
    [cd_produto]                INT        NULL,
    [vl_custo_produto_orcam]    FLOAT (53) NULL,
    [vl_custoant_produto_orcam] FLOAT (53) NULL,
    [dt_produto_orcamento]      DATETIME   NULL,
    [qt_diametro_produto_orcam] FLOAT (53) NULL,
    [ic_base_estampo]           CHAR (1)   NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    [qt_medida_c_minimo]        FLOAT (53) NULL,
    [qt_altura_arruela_pino_dc] FLOAT (53) NULL,
    [qt_medida_e_pino_dc]       FLOAT (53) NULL,
    CONSTRAINT [FK_Produto_Orcamento_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

