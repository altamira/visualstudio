﻿CREATE TABLE [dbo].[Produto_Compra] (
    [cd_produto]               INT          NOT NULL,
    [nm_compra_produto]        VARCHAR (40) NULL,
    [nm_marca_produto]         VARCHAR (30) NULL,
    [cd_unidade_medida]        INT          NULL,
    [qt_fatcompra_produto]     FLOAT (53)   NULL,
    [cd_destinacao_produto]    INT          NULL,
    [cd_aplicacao_produto]     INT          NULL,
    [nm_obs_aplicacao_produto] VARCHAR (60) NULL,
    [nm_obs_producao_produto]  VARCHAR (60) NULL,
    [qt_mes_compra_produto]    FLOAT (53)   NULL,
    [qt_lotecompra_produto]    CHAR (1)     NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_fase_produto]          INT          NULL,
    [cd_fase_produto_entrada]  INT          NULL,
    [ds_produto_compra]        TEXT         NULL,
    [nm_produto_compra]        VARCHAR (40) NULL,
    [ic_cotacao_grupo_produt]  CHAR (1)     NULL,
    [ic_cotacao_produto]       CHAR (1)     NULL,
    [cd_plano_compra]          INT          NULL,
    [qt_dia_validade_minima]   INT          NULL,
    CONSTRAINT [PK_Produto_Compra] PRIMARY KEY CLUSTERED ([cd_produto] ASC) WITH (FILLFACTOR = 90)
);

