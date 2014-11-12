﻿CREATE TABLE [dbo].[Processo_Producao_Componente] (
    [cd_processo]                  INT          NOT NULL,
    [cd_componente_processo]       INT          NOT NULL,
    [cd_seq_comp_processo]         INT          NULL,
    [cd_produto]                   INT          NULL,
    [cd_placa_processo]            INT          NULL,
    [qt_comp_processo]             FLOAT (53)   NULL,
    [nm_comp_processo]             VARCHAR (15) NULL,
    [cd_fase_produto]              INT          NULL,
    [ic_esp_comp_processo]         CHAR (1)     NULL,
    [nm_medida_comp_processo]      VARCHAR (25) NULL,
    [cd_mat_prima]                 INT          NULL,
    [nm_obs_comp_processo]         VARCHAR (60) NULL,
    [cd_usuario]                   INT          NULL,
    [dt_usuario]                   DATETIME     NULL,
    [ic_estoque_processo]          CHAR (1)     NULL,
    [pc_refugo_processo]           FLOAT (53)   NULL,
    [cd_unidade_medida]            INT          NULL,
    [cd_movimento_estoque]         INT          NULL,
    [ic_pcp_comp_processo]         CHAR (1)     NULL,
    [cd_ordem]                     INT          NULL,
    [qt_compr_comp_processo]       FLOAT (53)   NULL,
    [qt_larg_comp_processo]        FLOAT (53)   NULL,
    [qt_esp_comp_processo]         FLOAT (53)   NULL,
    [ic_redondo_comp_processo]     CHAR (1)     NULL,
    [qt_processo_padrao]           FLOAT (53)   NULL,
    [cd_movimento_estoque_reserva] INT          NULL,
    [ic_componente_substituto]     CHAR (1)     NULL,
    [cd_desenho_item_processo]     VARCHAR (30) NULL,
    [cd_rev_des_item_processo]     VARCHAR (5)  NULL,
    [cd_lote_item_processo]        VARCHAR (25) NULL,
    [ic_custo_produto_processo]    CHAR (1)     NULL,
    [qt_real_processo]             FLOAT (53)   NULL,
    [cd_processo_origem]           INT          NULL,
    [cd_requisicao_interna]        INT          NULL,
    [cd_item_req_interna]          INT          NULL,
    [cd_processo_destino]          INT          NULL,
    CONSTRAINT [PK_Processo_Producao_Componente] PRIMARY KEY CLUSTERED ([cd_processo] ASC, [cd_componente_processo] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_Processo_Producao_Componente_cd_processo_cd_produto]
    ON [dbo].[Processo_Producao_Componente]([cd_processo] ASC, [cd_produto] ASC) WITH (FILLFACTOR = 90);

