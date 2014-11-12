﻿CREATE TABLE [dbo].[Parametro_Produto] (
    [cd_empresa]                  INT      NOT NULL,
    [cd_usuario]                  INT      NULL,
    [dt_usuario]                  DATETIME NULL,
    [ic_valida_descricao_produto] CHAR (1) NULL,
    [ic_saldo_reserva_produto]    CHAR (1) NULL,
    [ic_saldo_real_produto]       CHAR (1) NULL,
    [ic_novo_fantasia_produto]    CHAR (1) NULL,
    [ic_finalidade_produto]       CHAR (1) NULL,
    [ic_classificacao_fiscal]     CHAR (1) NULL,
    [ic_altera_fantasia_produto]  CHAR (1) NULL,
    [ic_desenho_produto]          CHAR (1) NULL,
    [ic_custo_consulta_produto]   CHAR (1) NULL,
    [ic_valida_fantasia_produto]  CHAR (1) NULL,
    [ic_valida_codigo_produto]    CHAR (1) NULL,
    [ic_desc_tec_cad_produto]     CHAR (1) NULL,
    [ic_faixa_preco_produto]      CHAR (1) NULL,
    [cd_tipo_faixa_preco]         INT      NULL,
    [ic_desc_tec_janela]          CHAR (1) NULL,
    [ic_catalogo_produto]         CHAR (1) NULL,
    [ic_foto_produto]             CHAR (1) NULL,
    [cd_unidade_medida]           INT      NULL,
    [ic_custo_comissao_produto]   CHAR (1) NULL,
    [ic_estampo_produto]          CHAR (1) NULL,
    [ic_quimico_produto]          CHAR (1) NULL,
    [ic_cliente_produto]          CHAR (1) NULL,
    [ic_fantasia_grupo_produto]   CHAR (1) NULL,
    [ic_isento_ipi_produto]       CHAR (1) NULL,
    [ic_sequencial_produto]       CHAR (1) NULL,
    [ic_fase_grupo_produto]       CHAR (1) NULL,
    [ic_codificacao_cadastro]     CHAR (1) NULL,
    [ic_composicao_produto]       CHAR (1) NULL,
    [ic_peso_especifico_processo] CHAR (1) NULL,
    CONSTRAINT [PK_Parametro_Produto] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parametro_Produto_Tipo_Faixa_Preco_Produto] FOREIGN KEY ([cd_tipo_faixa_preco]) REFERENCES [dbo].[Tipo_Faixa_Preco_Produto] ([cd_tipo_faixa_preco]),
    CONSTRAINT [FK_Parametro_Produto_Unidade_Medida] FOREIGN KEY ([cd_unidade_medida]) REFERENCES [dbo].[Unidade_Medida] ([cd_unidade_medida])
);

