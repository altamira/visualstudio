CREATE TABLE [dbo].[Movimento_Estoque] (
    [cd_movimento_estoque]        INT           NOT NULL,
    [dt_movimento_estoque]        DATETIME      NULL,
    [cd_tipo_movimento_estoque]   INT           NULL,
    [cd_documento_movimento]      VARCHAR (20)  NULL,
    [cd_item_documento]           INT           NULL,
    [cd_tipo_documento_estoque]   INT           NULL,
    [dt_documento_movimento]      DATETIME      NULL,
    [cd_centro_custo]             INT           NULL,
    [qt_movimento_estoque]        FLOAT (53)    NULL,
    [vl_unitario_movimento]       FLOAT (53)    NULL,
    [vl_total_movimento]          FLOAT (53)    NULL,
    [ic_peps_movimento_estoque]   CHAR (1)      NULL,
    [ic_terceiro_movimento]       CHAR (1)      NULL,
    [ic_consig_movimento]         CHAR (1)      NULL,
    [nm_historico_movimento]      VARCHAR (255) NULL,
    [ic_mov_movimento]            CHAR (1)      NULL,
    [cd_fornecedor]               INT           NULL,
    [cd_produto]                  INT           NULL,
    [cd_fase_produto]             INT           NULL,
    [ic_fase_entrada_movimento]   CHAR (1)      NULL,
    [cd_fase_produto_entrada]     INT           NULL,
    [ds_observacao_movimento]     VARCHAR (40)  NULL,
    [vl_fob_produto]              FLOAT (53)    NULL,
    [cd_lote_produto]             VARCHAR (25)  NULL,
    [vl_custo_contabil_produto]   FLOAT (53)    NULL,
    [nm_referencia_movimento]     VARCHAR (30)  NULL,
    [cd_usuario]                  INT           NULL,
    [dt_usuario]                  DATETIME      NULL,
    [cd_origem_baixa_produto]     INT           NULL,
    [cd_item_movimento]           INT           NULL,
    [ic_consig_mov_estoque]       CHAR (1)      NULL,
    [cd_unidade_medida]           INT           NULL,
    [cd_historico_estoque]        INT           NULL,
    [cd_tipo_destinatario]        INT           NULL,
    [nm_destinatario]             VARCHAR (40)  NULL,
    [nm_invoice]                  VARCHAR (40)  NULL,
    [nm_di]                       VARCHAR (40)  NULL,
    [vl_fob_convertido]           FLOAT (53)    NULL,
    [ic_tipo_lancto_movimento]    CHAR (1)      NULL,
    [ic_amostra_movimento]        CHAR (1)      NULL,
    [cd_item_composicao]          INT           NULL,
    [ic_canc_movimento_estoque]   CHAR (1)      NULL,
    [cd_movimento_estoque_origem] INT           NULL,
    [cd_movimento_saida_original] INT           NULL,
    [cd_aplicacao_produto]        INT           NULL,
    [cd_serie_nota_fiscal]        INT           NULL,
    [cd_operacao_fiscal]          INT           NULL,
    [ic_tipo_terc_movimento]      CHAR (1)      NULL,
    [ic_tipo_consig_movimento]    CHAR (1)      NULL,
    [cd_unidade_origem]           INT           NULL,
    [qt_fator_produto_unidade]    FLOAT (53)    NULL,
    [qt_origem_movimento]         FLOAT (53)    NULL,
    [cd_loja]                     INT           NULL,
    [qt_peso_movimento_estoque]   FLOAT (53)    NULL,
    [vl_custo_comissao]           FLOAT (53)    NULL,
    [ic_nf_complemento]           CHAR (1)      NULL,
    CONSTRAINT [PK_Movimento_Estoque] PRIMARY KEY CLUSTERED ([cd_movimento_estoque] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_Movimento_Estoque_dt_movimento_estoque]
    ON [dbo].[Movimento_Estoque]([dt_movimento_estoque] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Movimento_Estoque_cd_produto]
    ON [dbo].[Movimento_Estoque]([cd_produto] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Movimento_Estoque_cd_fase_produto]
    ON [dbo].[Movimento_Estoque]([cd_fase_produto] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Movimento_Estoque]
    ON [dbo].[Movimento_Estoque]([cd_movimento_estoque] ASC) WITH (FILLFACTOR = 90);

