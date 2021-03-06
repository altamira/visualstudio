﻿CREATE TABLE [dbo].[Processo_Padrao] (
    [cd_processo_padrao]         INT           NOT NULL,
    [nm_processo_padrao]         VARCHAR (50)  NULL,
    [dt_processo_padrao]         DATETIME      NULL,
    [nm_obs_processo_padrao]     TEXT          NULL,
    [cd_usuario]                 INT           NULL,
    [dt_usuario]                 DATETIME      NULL,
    [cd_grupo_produto]           INT           NULL,
    [ic_tipo_montagem]           CHAR (1)      NULL,
    [vl_custo_operacao]          FLOAT (53)    NULL,
    [vl_custo_componente]        FLOAT (53)    NULL,
    [cd_unidade_medida]          INT           NULL,
    [pc_perda_processo]          FLOAT (53)    NULL,
    [qt_densidade_processo]      FLOAT (53)    NULL,
    [nm_identificacao_processo]  VARCHAR (30)  NULL,
    [cd_padrao_cor]              INT           NULL,
    [qt_processo_padrao]         FLOAT (53)    NULL,
    [cd_tipo_processo]           INT           NULL,
    [ic_fmea_processo_padrao]    CHAR (1)      NULL,
    [nm_imagem_processo]         VARCHAR (100) NULL,
    [nm_documento_processo]      VARCHAR (100) NULL,
    [ic_plano_processo_padrao]   CHAR (1)      NULL,
    [cd_status_processo_padrao]  INT           NULL,
    [vl_total_custo_processo]    FLOAT (53)    NULL,
    [vl_custo_servico]           FLOAT (53)    NULL,
    [vl_custo_maquina]           FLOAT (53)    NULL,
    [cd_unidade_producao]        INT           NULL,
    [qt_producao_processo]       FLOAT (53)    NULL,
    [dt_custo_processo]          DATETIME      NULL,
    [cd_usuario_custo_processo]  INT           NULL,
    [cd_desenho_processo_padrao] VARCHAR (30)  NULL,
    [nm_caminho_desenho]         VARCHAR (100) NULL,
    [cd_rev_des_processo_padrao] VARCHAR (5)   NULL,
    [vl_custo_embalagem]         FLOAT (53)    NULL,
    [ic_custo_processo_padrao]   CHAR (1)      NULL,
    [qt_peso_especifico]         FLOAT (53)    NULL,
    CONSTRAINT [PK_Processo_Padrao] PRIMARY KEY CLUSTERED ([cd_processo_padrao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Padrao_Tipo_Processo] FOREIGN KEY ([cd_tipo_processo]) REFERENCES [dbo].[Tipo_Processo] ([cd_tipo_processo]),
    CONSTRAINT [FK_Processo_Padrao_Unidade_Medida] FOREIGN KEY ([cd_unidade_producao]) REFERENCES [dbo].[Unidade_Medida] ([cd_unidade_medida])
);

