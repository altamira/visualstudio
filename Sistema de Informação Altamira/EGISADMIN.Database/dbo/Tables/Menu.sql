﻿CREATE TABLE [dbo].[Menu] (
    [cd_menu]                  INT           NOT NULL,
    [nm_menu]                  VARCHAR (40)  NULL,
    [cd_classe]                INT           NULL,
    [nm_menu_titulo]           VARCHAR (60)  NULL,
    [ic_menu_visivel]          CHAR (1)      NULL,
    [nm_mensagem_menu]         VARCHAR (40)  NULL,
    [ds_observacao]            TEXT          NULL,
    [cd_senha_acesso_menu]     CHAR (10)     NULL,
    [nm_form_menu]             VARCHAR (40)  NULL,
    [nm_unit_menu]             CHAR (40)     NULL,
    [cd_tipo_menu]             INT           NULL,
    [cd_nivel_acesso]          INT           NULL,
    [cd_imagem]                INT           NULL,
    [cd_help]                  INT           NULL,
    [cd_menu_superior]         INT           NULL,
    [cd_usuario]               INT           NULL,
    [dt_usuario]               DATETIME      NULL,
    [ic_mdi]                   CHAR (1)      NULL,
    [sg_tipo_opcao]            CHAR (1)      NULL,
    [nm_executavel]            VARCHAR (100) NULL,
    [ic_alteracao]             CHAR (1)      NULL,
    [ic_grafico_menu]          CHAR (1)      NULL,
    [ic_iso_menu]              CHAR (1)      NULL,
    [cd_procedimento]          INT           NULL,
    [cd_view]                  INT           NULL,
    [ic_expandido_menu]        CHAR (1)      NULL,
    [cd_pacote]                INT           NULL,
    [ic_habilitado]            CHAR (1)      NULL,
    [ic_nucleo_menu]           CHAR (1)      NULL,
    [ds_observacao_menu]       TEXT          NULL,
    [ic_manual_menu]           CHAR (1)      NULL,
    [cd_iso_processo]          INT           NULL,
    [nm_doc_iso_menu]          VARCHAR (100) NULL,
    [cd_funcao_sql]            INT           NULL,
    [cd_pagina]                INT           NULL,
    [nm_video_menu]            VARCHAR (100) NULL,
    [ic_comparativo_menu]      CHAR (1)      NULL,
    [qt_hora_treinamento_menu] FLOAT (53)    NULL,
    [cd_tipo_versao]           INT           NULL,
    [ic_grava_posicao_grid]    CHAR (1)      NULL,
    [ic_panel_help]            CHAR (1)      NULL,
    [ic_centralizado_menu]     CHAR (1)      NULL,
    [ic_forma_acesso_menu]     CHAR (1)      NULL,
    [ic_registro_tabela_menu]  CHAR (1)      NULL,
    CONSTRAINT [PK_Menu] PRIMARY KEY CLUSTERED ([cd_menu] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_Menu]
    ON [dbo].[Menu]([cd_menu] ASC) WITH (FILLFACTOR = 90);

