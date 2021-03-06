﻿CREATE TABLE [dbo].[Processo_Producao] (
    [cd_processo]                  INT           NOT NULL,
    [dt_processo]                  DATETIME      NULL,
    [qt_prioridade_processo]       FLOAT (53)    NULL,
    [cd_pedido_venda]              INT           NULL,
    [cd_item_pedido_venda]         INT           NULL,
    [ds_processo]                  TEXT          NULL,
    [ic_listado_processo]          CHAR (1)      NULL,
    [ic_libprog_processo]          CHAR (1)      NULL,
    [qt_hora_processo]             FLOAT (53)    NULL,
    [dt_prog_processo]             DATETIME      NULL,
    [dt_alt_processo]              DATETIME      NULL,
    [nm_alteracao_processo]        VARCHAR (80)  NULL,
    [dt_canc_processo]             DATETIME      NULL,
    [nm_canc_processo]             VARCHAR (40)  NULL,
    [dt_mp_processo]               DATETIME      NULL,
    [cd_identifica_processo]       VARCHAR (20)  NULL,
    [ic_compesp_processo]          CHAR (1)      NULL,
    [ic_mapa_processo]             CHAR (1)      NULL,
    [ic_aponta_processo]           CHAR (1)      NULL,
    [dt_fimprod_processo]          DATETIME      NULL,
    [ic_arvore_processo]           CHAR (1)      NULL,
    [cd_usuario_processo]          INT           NULL,
    [nm_mp_processo_producao]      VARCHAR (50)  NULL,
    [dt_liberacao_processo]        DATETIME      NULL,
    [cd_usuario]                   INT           NULL,
    [dt_usuario]                   DATETIME      NULL,
    [cd_projeto]                   INT           NULL,
    [cd_item_projeto]              INT           NULL,
    [ic_estado_processo]           CHAR (1)      NULL,
    [cd_fase_produto]              INT           NULL,
    [cd_origem_processo]           INT           NULL,
    [cd_status_processo]           INT           NULL,
    [qt_refugo_processo]           FLOAT (53)    NULL,
    [qt_produzido_processo]        FLOAT (53)    NULL,
    [pc_refugo_processo]           FLOAT (53)    NULL,
    [qt_planejada_processo]        FLOAT (53)    NULL,
    [dt_entrega_processo]          DATETIME      NULL,
    [dt_inicio_processo]           DATETIME      NULL,
    [cd_produto]                   INT           NULL,
    [cd_produto_pai]               INT           NULL,
    [qt_hora_setup]                FLOAT (53)    NULL,
    [ds_processo_fabrica]          TEXT          NULL,
    [nm_processista]               VARCHAR (30)  NULL,
    [cd_projeto_material]          INT           NULL,
    [ic_componente_proc_padrao]    CHAR (1)      NULL,
    [ic_composicao_proc_padrao]    CHAR (1)      NULL,
    [qt_hora_prevista]             FLOAT (53)    NULL,
    [qt_setup_previsto]            FLOAT (53)    NULL,
    [cd_processo_padrao]           INT           NULL,
    [cd_usuario_mapa_processo]     INT           NULL,
    [cd_usuario_lib_processo]      INT           NULL,
    [nm_obs_prog_processo]         VARCHAR (40)  NULL,
    [ic_prog_mapa_processo]        CHAR (1)      NULL,
    [dt_encerramento_processo]     DATETIME      NULL,
    [dt_entrega_prog_processo]     DATETIME      NULL,
    [cd_tipo_processo]             INT           NULL,
    [nm_documento_processo]        VARCHAR (100) NULL,
    [nm_imagem_processo]           VARCHAR (100) NULL,
    [ic_fmea_processo]             CHAR (1)      NULL,
    [ic_plano_processo]            CHAR (1)      NULL,
    [ds_especificacao_tecnica]     TEXT          NULL,
    [qt_faturado_processo]         FLOAT (53)    NULL,
    [nm_numero_apontamento]        VARCHAR (15)  NULL,
    [cd_cliente]                   INT           NULL,
    [cd_item_requisicao]           INT           NULL,
    [cd_requisicao]                INT           NULL,
    [qt_saldo_produto_processo]    FLOAT (53)    NULL,
    [qt_minimo_produto_processo]   FLOAT (53)    NULL,
    [qt_producao_produto_processo] FLOAT (53)    NULL,
    [cd_id_item_pedido_venda]      INT           NULL,
    [cd_rnc]                       INT           NULL,
    [cd_desenho_processo_produto]  VARCHAR (30)  NULL,
    [cd_rev_des_processo_produto]  VARCHAR (5)   NULL,
    [cd_lote_produto_processo]     VARCHAR (25)  NULL,
    [nm_situacao_op]               VARCHAR (30)  NULL,
    [cd_programacao_entrega]       INT           NULL,
    [cd_processo_origem]           INT           NULL,
    [cd_plano_mrp]                 INT           NULL,
    CONSTRAINT [PK_Processo_Producao] PRIMARY KEY CLUSTERED ([cd_processo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Producao_Origem_Processo] FOREIGN KEY ([cd_origem_processo]) REFERENCES [dbo].[Origem_Processo] ([cd_origem_processo]),
    CONSTRAINT [FK_Processo_Producao_Pedido_Venda] FOREIGN KEY ([cd_pedido_venda]) REFERENCES [dbo].[Pedido_Venda] ([cd_pedido_venda]),
    CONSTRAINT [FK_Processo_Producao_Status_Processo] FOREIGN KEY ([cd_status_processo]) REFERENCES [dbo].[Status_Processo] ([cd_status_processo]),
    CONSTRAINT [FK_Processo_Producao_Tipo_Processo] FOREIGN KEY ([cd_tipo_processo]) REFERENCES [dbo].[Tipo_Processo] ([cd_tipo_processo])
);

