CREATE TABLE [dbo].[Parametro_Produto_Finalidade] (
    [cd_empresa]                INT      NOT NULL,
    [cd_modulo]                 INT      NOT NULL,
    [cd_usuario]                INT      NULL,
    [dt_usuario]                DATETIME NULL,
    [ic_comercial_produto]      CHAR (1) NULL,
    [ic_compra_produto]         CHAR (1) NULL,
    [ic_producao_produto]       CHAR (1) NULL,
    [ic_importacao_produto]     CHAR (1) NULL,
    [ic_processo_produto]       CHAR (1) NULL,
    [ic_exportacao_produto]     CHAR (1) NULL,
    [ic_beneficiamento_produto] CHAR (1) NULL,
    [ic_amostra_produto]        CHAR (1) NULL,
    [ic_consignacao_produto]    CHAR (1) NULL,
    [ic_transferencia_produto]  CHAR (1) NULL,
    [ic_revenda_produto]        CHAR (1) NULL,
    [ic_sob_encomenda_produto]  CHAR (1) NULL,
    [ic_tecnica_produto]        CHAR (1) NULL,
    [ic_pcp_produto]            CHAR (1) NULL,
    [ic_almox_produto]          CHAR (1) NULL,
    CONSTRAINT [PK_Parametro_Produto_Finalidade] PRIMARY KEY CLUSTERED ([cd_empresa] ASC, [cd_modulo] ASC) WITH (FILLFACTOR = 90)
);

