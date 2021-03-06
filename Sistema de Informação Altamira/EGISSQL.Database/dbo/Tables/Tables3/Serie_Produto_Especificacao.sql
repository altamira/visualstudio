﻿CREATE TABLE [dbo].[Serie_Produto_Especificacao] (
    [cd_serie_produto]          INT          NOT NULL,
    [qt_area_serie_produto]     FLOAT (53)   NULL,
    [qt_dimext_comp_serie_prod] FLOAT (53)   NULL,
    [nm_dimext_serie_produto]   VARCHAR (40) NULL,
    [cd_tipo_mercado]           INT          NULL,
    [cd_grupo_produto]          INT          NULL,
    [cd_concorrente]            INT          NULL,
    [nm_obs_serie_produto]      VARCHAR (40) NULL,
    [qt_areasug_larg_serie_pro] FLOAT (53)   NULL,
    [qt_areasug_comp_serie_pro] FLOAT (53)   NULL,
    [ic_normal_serie_produto]   CHAR (1)     NULL,
    [ic_flutuante_serie_prod]   CHAR (1)     NULL,
    [ic_capilar_serie_produto]  CHAR (1)     NULL,
    [qt_ssnini_serie_produto]   FLOAT (53)   NULL,
    [qt_ssnfin_serie_produto]   FLOAT (53)   NULL,
    [qt_sflini_serie_produto]   FLOAT (53)   NULL,
    [qt_sflfim_serie_produto]   FLOAT (53)   NULL,
    [qt_scaini_serie_produto]   FLOAT (53)   NULL,
    [qt_scafim_serie_produto]   FLOAT (53)   NULL,
    [qt_montn_serie_produto]    FLOAT (53)   NULL,
    [qt_montf_serie_produto]    FLOAT (53)   NULL,
    [qt_montc_serie_produto]    FLOAT (53)   NULL,
    [qt_tipon_serie_produto]    FLOAT (53)   NULL,
    [qt_tipof_serie_produto]    FLOAT (53)   NULL,
    [qt_tipoc_serie_produto]    FLOAT (53)   NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [qt_dimext_larg_serie_prod] FLOAT (53)   NULL,
    [qt_dimext_aba_serie_prod]  FLOAT (53)   NULL,
    [cd_tipo_lucro]             INT          NULL,
    [qt_tempo_ret_tangencial]   FLOAT (53)   NULL,
    CONSTRAINT [PK_Serie_Produto_Especificacao] PRIMARY KEY CLUSTERED ([cd_serie_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Serie_Produto_Especificacao_Grupo_Produto] FOREIGN KEY ([cd_grupo_produto]) REFERENCES [dbo].[Grupo_Produto] ([cd_grupo_produto]),
    CONSTRAINT [FK_Serie_Produto_Especificacao_Tipo_Mercado] FOREIGN KEY ([cd_tipo_mercado]) REFERENCES [dbo].[Tipo_Mercado] ([cd_tipo_mercado])
);

