﻿CREATE TABLE [dbo].[Processo_Producao_Composicao] (
    [cd_processo]               INT          NOT NULL,
    [cd_item_processo]          INT          NOT NULL,
    [cd_seq_processo]           INT          NULL,
    [cd_maquina]                INT          NULL,
    [nm_maqcompl_processo]      VARCHAR (25) NULL,
    [cd_operacao]               INT          NULL,
    [nm_opecompl_processo]      VARCHAR (25) NULL,
    [qt_hora_estimado_processo] FLOAT (53)   NULL,
    [qt_hora_real_processo]     FLOAT (53)   NULL,
    [dt_prog_mapa_processo]     DATETIME     NULL,
    [cd_servico_especial]       INT          NULL,
    [ic_operacao_mapa_processo] CHAR (1)     NULL,
    [nm_obs_item_processo]      VARCHAR (40) NULL,
    [cd_grupo_maquina]          INT          NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [qt_seq_ant_processo]       INT          NULL,
    [qt_dia_processo]           INT          NULL,
    [dt_programacao_processo]   DATETIME     NULL,
    [ic_apontamento_operacao]   CHAR (1)     NULL,
    [qt_hora_setup_processo]    FLOAT (53)   NULL,
    [dt_estimada_operacao]      DATETIME     NULL,
    [cd_ordem]                  INT          NULL,
    [cd_fornecedor]             INT          NULL,
    [cd_composicao_proc_padrao] INT          NULL,
    [ic_movimenta_estoque]      CHAR (1)     NULL,
    [cd_maquina_processo]       INT          NULL,
    [ic_operacao_priorizada]    CHAR (1)     NULL,
    [ic_inspecao_operacao]      CHAR (1)     NULL,
    [qt_hora_prog_processo]     FLOAT (53)   NULL,
    CONSTRAINT [PK_Processo_Producao_Composicao] PRIMARY KEY CLUSTERED ([cd_processo] ASC, [cd_item_processo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Producao_Composicao_Operacao] FOREIGN KEY ([cd_operacao]) REFERENCES [dbo].[Operacao] ([cd_operacao])
);

