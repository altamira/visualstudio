﻿CREATE TABLE [dbo].[Consulta_Item_Estampo] (
    [cd_consulta]                 INT          NOT NULL,
    [cd_item_consulta]            INT          NOT NULL,
    [cd_produto_estampo]          INT          NULL,
    [cd_codificacao_produto]      VARCHAR (25) NULL,
    [nm_fantasia_produto_estampo] VARCHAR (25) NULL,
    [nm_produto_estampo]          VARCHAR (50) NULL,
    [qt_diametro_interno]         FLOAT (53)   NULL,
    [qt_diametro_externo]         FLOAT (53)   NULL,
    [qt_espessura]                FLOAT (53)   NULL,
    [qt_altura]                   FLOAT (53)   NULL,
    [qt_tol_diametro_interno]     FLOAT (53)   NULL,
    [qt_tol_diametro_externo]     FLOAT (53)   NULL,
    [qt_tol_espessura]            FLOAT (53)   NULL,
    [qt_tol_altura]               FLOAT (53)   NULL,
    [cd_mat_prima]                INT          NULL,
    [cd_tratamento_produto]       INT          NULL,
    [cd_acabamento_produto]       INT          NULL,
    [ds_especificacao_produto]    TEXT         NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    [qt_producao_anterior]        FLOAT (53)   NULL,
    [qt_minimo_produto]           FLOAT (53)   NULL,
    [qt_producao]                 FLOAT (53)   NULL,
    [qt_prazo_fabricacao]         FLOAT (53)   NULL,
    [nm_obs_produto_estampo]      VARCHAR (40) NULL,
    [qt_produto_kg]               FLOAT (53)   NULL,
    CONSTRAINT [PK_Consulta_Item_Estampo] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_item_consulta] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Consulta_Item_Estampo_Acabamento_Produto] FOREIGN KEY ([cd_acabamento_produto]) REFERENCES [dbo].[Acabamento_Produto] ([cd_acabamento_produto])
);

