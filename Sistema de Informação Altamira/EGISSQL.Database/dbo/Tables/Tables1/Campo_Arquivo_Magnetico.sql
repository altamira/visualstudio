﻿CREATE TABLE [dbo].[Campo_Arquivo_Magnetico] (
    [cd_sessao_documento]     INT          NOT NULL,
    [cd_campo_magnetico]      INT          NOT NULL,
    [cd_tipo_campo]           INT          NULL,
    [qt_tamanho]              INT          NULL,
    [qt_decimal]              INT          NULL,
    [ic_arredondamento_valor] CHAR (1)     NULL,
    [cd_inicio_posicao]       INT          NULL,
    [cd_fim_posicao]          INT          NULL,
    [nm_conteudo_fixo]        VARCHAR (50) NULL,
    [nm_tabela_origem]        VARCHAR (50) NULL,
    [nm_campo_origem]         VARCHAR (50) NULL,
    [nm_campo_chave]          VARCHAR (50) NULL,
    [nm_conteudo_chave]       VARCHAR (50) NULL,
    [nm_tabela_ligacao]       VARCHAR (40) NULL,
    [nm_campo_ligacao]        VARCHAR (50) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [nm_instrucao_sql]        TEXT         NULL,
    [nm_campo]                VARCHAR (40) NULL,
    [ds_campo]                VARCHAR (40) NULL,
    [cd_arquivo_magnetico]    INT          NULL,
    [ic_groupby]              CHAR (1)     NULL,
    [ic_valor_digitado]       CHAR (1)     NULL,
    [cd_posicao_orderby]      INT          NULL,
    [ic_incluir_no_arquivo]   CHAR (1)     NULL,
    [ic_mostrar_no_relatorio] CHAR (1)     NULL,
    [ic_totalizacao_grid]     CHAR (1)     NULL,
    [ic_gera_tag_campo]       CHAR (1)     NULL,
    [ic_gera_tag_abe_campo]   CHAR (1)     NULL,
    [ic_gera_tag_fec_campo]   CHAR (1)     NULL,
    [ic_linha_campo]          CHAR (1)     NULL,
    [ic_sem_tab_campo]        CHAR (1)     NULL,
    [ic_tributacao_icms_00]   CHAR (1)     NULL,
    [ic_tributacao_icms_10]   CHAR (1)     NULL,
    [ic_tributacao_icms_20]   CHAR (1)     NULL,
    [ic_tributacao_icms_30]   CHAR (1)     NULL,
    [ic_tributacao_icms_40]   CHAR (1)     NULL,
    [ic_tributacao_icms_41]   CHAR (1)     NULL,
    [ic_tributacao_icms_50]   CHAR (1)     NULL,
    [ic_tributacao_icms_51]   CHAR (1)     NULL,
    [ic_tributacao_icms_60]   CHAR (1)     NULL,
    [ic_tributacao_icms_70]   CHAR (1)     NULL,
    [ic_tributacao_icms_90]   CHAR (1)     NULL,
    CONSTRAINT [PK_Campo_Arquivo_Magnetico] PRIMARY KEY CLUSTERED ([cd_sessao_documento] ASC, [cd_campo_magnetico] ASC) WITH (FILLFACTOR = 90)
);

