﻿CREATE TABLE [dbo].[Grupo_Produto_Custo] (
    [cd_grupo_produto]          INT        NOT NULL,
    [ic_custo]                  CHAR (1)   NULL,
    [ic_lista_preco]            CHAR (1)   NULL,
    [ic_estoque_grupo_prod]     CHAR (1)   NULL,
    [ic_imediato_grupo_prod]    CHAR (1)   NULL,
    [ic_lista_rep_grupo_prod]   CHAR (1)   NULL,
    [qt_dia_entrega_grupo_prod] FLOAT (53) NULL,
    [ic_importado_grupo_prod]   CHAR (1)   NULL,
    [ic_reserva_estoque]        CHAR (1)   NULL,
    [ic_estoque_fatura]         CHAR (1)   NULL,
    [ic_estoque_venda]          CHAR (1)   NULL,
    [ic_venda_saldo_neg_grupo]  CHAR (1)   NULL,
    [ic_controle_desconto]      CHAR (1)   NULL,
    [ic_fechamento_mensal]      CHAR (1)   NULL,
    [ic_orcamento]              CHAR (1)   NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    [ic_peps]                   CHAR (1)   NULL,
    [ic_volume_grupo_produto]   CHAR (1)   NULL,
    [ic_etiq_pcp_grupo_produto] CHAR (1)   NULL,
    [ic_processo_grupo_produto] CHAR (1)   NULL,
    [ic_transf_cust_grupo_prod] CHAR (1)   NULL,
    [ic_repos_grupo_produto]    CHAR (1)   NULL,
    [ic_export_grupo_produto]   CHAR (1)   NULL,
    [ic_especial_grupo_produto] CHAR (1)   NULL,
    [ic_inspecao_grupo_produto] CHAR (1)   NULL,
    [ic_qualid_grupo_produto]   CHAR (1)   NULL,
    [ic_smo_grupo_produto]      CHAR (1)   NULL,
    [cd_aplicacao_markup]       INT        NULL,
    [cd_tipo_lucro]             INT        NULL,
    [ic_om_custo_grupo_produto] CHAR (1)   NULL,
    [sg_produto_custo]          CHAR (5)   NULL,
    [ic_invent_fisico_grupo]    CHAR (1)   NULL,
    [ic_mat_prima_grupo]        CHAR (1)   NULL,
    [cd_grupo_inventario]       INT        NULL,
    [cd_lancamento_padrao]      INT        NULL,
    [cd_grupo_estoque]          INT        NULL,
    [ic_pcp_grupo_produto]      CHAR (1)   NULL,
    [cd_unidade_valoracao]      INT        NULL,
    [cd_servico_smo]            INT        NULL,
    [ic_deducao_imposto]        CHAR (1)   NULL,
    [cd_fase_produto]           INT        NULL,
    CONSTRAINT [pk_grupo_produto_custo] PRIMARY KEY CLUSTERED ([cd_grupo_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Grupo_Produto_Custo_Grupo_Estoque] FOREIGN KEY ([cd_grupo_estoque]) REFERENCES [dbo].[Grupo_Estoque] ([cd_grupo_estoque]),
    CONSTRAINT [FK_Grupo_Produto_Custo_Lancamento_Padrao] FOREIGN KEY ([cd_lancamento_padrao]) REFERENCES [dbo].[Lancamento_Padrao] ([cd_lancamento_padrao])
);

