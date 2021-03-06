﻿CREATE TABLE [dbo].[Previsao_Venda_Composicao] (
    [cd_previsao_venda]    INT          NOT NULL,
    [cd_item_previsao]     INT          NULL,
    [qt_mes_item_previsao] INT          NULL,
    [qt_item_previsao]     FLOAT (53)   NULL,
    [vl_item_previsao]     FLOAT (53)   NULL,
    [nm_obs_item_previsao] VARCHAR (40) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [vl_jan_previsao]      FLOAT (53)   NULL,
    [qt_jan_previsao]      FLOAT (53)   NULL,
    [vl_fev_previsao]      FLOAT (53)   NULL,
    [qt_fev_previsao]      FLOAT (53)   NULL,
    [vl_mar_previsao]      FLOAT (53)   NULL,
    [qt_mar_previsao]      FLOAT (53)   NULL,
    [vl_abr_previsao]      FLOAT (53)   NULL,
    [qt_abr_previsao]      FLOAT (53)   NULL,
    [vl_mai_previsao]      FLOAT (53)   NULL,
    [qt_mai_previsao]      FLOAT (53)   NULL,
    [vl_jun_previsao]      FLOAT (53)   NULL,
    [qt_jun_previsao]      FLOAT (53)   NULL,
    [vl_jul_previsao]      FLOAT (53)   NULL,
    [qt_jul_previsao]      FLOAT (53)   NULL,
    [vl_ago_previsao]      FLOAT (53)   NULL,
    [qt_ago_previsao]      FLOAT (53)   NULL,
    [vl_set_previsao]      FLOAT (53)   NULL,
    [qt_set_previsao]      FLOAT (53)   NULL,
    [vl_out_previsao]      FLOAT (53)   NULL,
    [qt_out_previsao]      FLOAT (53)   NULL,
    [vl_nov_previsao]      FLOAT (53)   NULL,
    [qt_nov_previsao]      FLOAT (53)   NULL,
    [vl_dez_previsao]      FLOAT (53)   NULL,
    [qt_dez_previsao]      FLOAT (53)   NULL,
    [vl_unitario_previsao] FLOAT (53)   NULL,
    [qt_potencial]         FLOAT (53)   NULL,
    CONSTRAINT [PK_Previsao_Venda_Composicao] PRIMARY KEY CLUSTERED ([cd_previsao_venda] ASC) WITH (FILLFACTOR = 90)
);

