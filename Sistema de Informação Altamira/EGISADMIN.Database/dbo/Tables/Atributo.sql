﻿CREATE TABLE [dbo].[Atributo] (
    [cd_tabela]                  INT           NOT NULL,
    [cd_atributo]                INT           NOT NULL,
    [nm_atributo]                VARCHAR (40)  NULL,
    [cd_dominio]                 INT           NULL,
    [ds_atributo]                VARCHAR (40)  NULL,
    [cd_natureza_atributo]       INT           NOT NULL,
    [qt_tamanho_atributo]        INT           NULL,
    [qt_decimal_atributo]        INT           NULL,
    [nm_mascara_atributo]        VARCHAR (20)  NULL,
    [nm_atributo_relatorio]      VARCHAR (40)  NULL,
    [nm_atributo_consulta]       VARCHAR (40)  NULL,
    [ic_numeracao_automatica]    CHAR (1)      NULL,
    [ic_atributo_chave]          CHAR (1)      NULL,
    [nm_atributo_tabela_dbf]     CHAR (10)     NULL,
    [cd_help]                    INT           NULL,
    [ic_atributo_obrigatorio]    CHAR (1)      NOT NULL,
    [ic_mostra_grid]             CHAR (1)      NULL,
    [ic_edita_cadastro]          CHAR (1)      NULL,
    [ic_mostra_relatorio]        CHAR (1)      NULL,
    [ic_mostra_cadastro]         CHAR (1)      NULL,
    [vl_default]                 CHAR (20)     NULL,
    [nu_ordem]                   INT           NULL,
    [ic_chave_estrangeira]       CHAR (1)      NULL,
    [ic_combo_box]               CHAR (1)      NULL,
    [nm_campo_mostra_combo_box]  VARCHAR (120) NULL,
    [nm_tabela_combo_box]        VARCHAR (50)  NULL,
    [nm_campo_chave_combo_box]   VARCHAR (50)  NULL,
    [ic_lista_valor]             CHAR (1)      NULL,
    [nm_alias]                   VARCHAR (20)  NULL,
    [cd_usuario]                 INT           NULL,
    [dt_usuario]                 DATETIME      NULL,
    [ic_formata_string]          CHAR (1)      NULL,
    [ic_alteracao]               CHAR (1)      NULL,
    [ds_campo_help]              TEXT          NULL,
    [ic_atributo_clustered]      CHAR (1)      NULL,
    [qt_atributo_fillfactor]     INT           NULL,
    [ic_usar_spin]               CHAR (1)      NULL,
    [ic_aliasadmin_combo_box]    CHAR (1)      NULL,
    [ic_grafico_atributo]        CHAR (1)      NULL,
    [ic_grid_agrupado_atributo]  CHAR (1)      NULL,
    [ic_doc_caminho_atributo]    CHAR (1)      NULL,
    [ic_site_atributo]           CHAR (1)      NULL,
    [ic_tabela_composicao]       CHAR (1)      NULL,
    [nm_tabsheet_lookup]         VARCHAR (15)  NULL,
    [ic_filtro_atributo]         CHAR (1)      NULL,
    [ic_cep_atributo]            CHAR (1)      NULL,
    [ic_classe_atributo]         CHAR (1)      NULL,
    [cd_classe]                  INT           NULL,
    [ic_imagem_atributo]         CHAR (1)      NULL,
    [cd_imagem]                  INT           NULL,
    [ic_imagem_sistema_atributo] CHAR (1)      NULL,
    [cd_tabsheet]                INT           NULL,
    [ic_senha]                   CHAR (1)      NULL,
    [ic_codigo_barra]            CHAR (1)      NULL,
    [cd_tipo_codigo_barra]       INT           NULL,
    [ic_cor_atributo]            CHAR (1)      NULL,
    [ic_cor]                     CHAR (1)      NULL,
    [cd_tamanho_coluna]          INT           NULL,
    [ic_cidade_atributo]         CHAR (1)      NULL,
    [ic_endereco_atributo]       CHAR (1)      NULL,
    [ic_bairro_atributo]         CHAR (1)      NULL,
    [ic_pais_atributo]           CHAR (1)      NULL,
    CONSTRAINT [PK_Atributo] PRIMARY KEY CLUSTERED ([cd_tabela] ASC, [cd_atributo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Atributo_Classe] FOREIGN KEY ([cd_classe]) REFERENCES [dbo].[Classe] ([cd_classe])
);

