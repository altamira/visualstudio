CREATE TABLE [dbo].[Categoria_Produto] (
    [cd_grupo_categoria]         INT          NOT NULL,
    [cd_categoria_produto]       INT          NOT NULL,
    [cd_mascara_categoria]       VARCHAR (20) NOT NULL,
    [nm_categoria_produto]       VARCHAR (40) NOT NULL,
    [sg_categoria_produto]       CHAR (20)    NULL,
    [ic_vendas_categoria]        CHAR (1)     NOT NULL,
    [ic_fatura_categoria]        CHAR (1)     NOT NULL,
    [ic_impressao_categoria]     CHAR (1)     NOT NULL,
    [ic_valor_categoria]         CHAR (1)     NOT NULL,
    [ic_qtd_categoria]           CHAR (1)     NOT NULL,
    [ic_aberto_categoria]        CHAR (1)     NOT NULL,
    [cd_ordem_categoria]         INT          NULL,
    [cd_soma_categoria]          INT          NULL,
    [sg_resumo_categoria]        CHAR (20)    NULL,
    [cd_categoria_produto_pai]   INT          NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [vl_media_padrao]            FLOAT (53)   NULL,
    [pc_comissao_cat_produto]    FLOAT (53)   NULL,
    [ic_consumo_pad_categoria]   CHAR (1)     NULL,
    [ic_consumo_esp_categoria]   CHAR (1)     NULL,
    [ic_comissao_categoria]      CHAR (1)     NULL,
    [ic_resumo_comissao_categ]   CHAR (1)     NULL,
    [pc_desconto_categoria]      FLOAT (53)   NULL,
    [ic_total_categoria]         CHAR (1)     NULL,
    [ic_analise_categoria]       CHAR (1)     NULL,
    [cd_plano_financeiro]        INT          NULL,
    [cd_aplicacao_markup]        INT          NULL,
    [cd_tipo_lucro]              INT          NULL,
    [ic_cpv_categoria]           CHAR (1)     NULL,
    [pc_pcv_categoria]           FLOAT (53)   NULL,
    [pc_cpv_categoria]           FLOAT (53)   NULL,
    [ic_meta_vendedor_categoria] CHAR (1)     NULL,
    CONSTRAINT [PK_Categoria_Produto] PRIMARY KEY CLUSTERED ([cd_categoria_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Categoria_Produto_Aplicacao_Markup] FOREIGN KEY ([cd_aplicacao_markup]) REFERENCES [dbo].[Aplicacao_Markup] ([cd_aplicacao_markup]),
    CONSTRAINT [FK_Categoria_produto_Grupo_Categoria] FOREIGN KEY ([cd_grupo_categoria]) REFERENCES [dbo].[Grupo_Categoria] ([cd_grupo_categoria]),
    CONSTRAINT [FK_Categoria_Produto_Tipo_Lucro] FOREIGN KEY ([cd_tipo_lucro]) REFERENCES [dbo].[Tipo_Lucro] ([cd_tipo_lucro])
);


GO
CREATE NONCLUSTERED INDEX [ix_cd_mascara_categoria]
    ON [dbo].[Categoria_Produto]([cd_mascara_categoria] ASC) WITH (FILLFACTOR = 90);


GO

CREATE TRIGGER tD_Categoria_Produto
ON Categoria_Produto
FOR DELETE
AS 
BEGIN
   /*Exluir todos as sub-categorias*/
   Delete Categoria_Produto from Categoria_Produto, Deleted where Categoria_Produto.cd_categoria_produto_pai = Deleted.cd_categoria_produto
END
