CREATE TABLE [dbo].[Tipo_Mercado] (
    [cd_tipo_mercado]            INT          NOT NULL,
    [nm_tipo_mercado]            VARCHAR (40) NULL,
    [sg_tipo_mercado]            CHAR (10)    NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [ds_tipo_mercado]            TEXT         NULL,
    [ic_padrao_tipo_mercado]     CHAR (1)     NULL,
    [ic_end_esp_tipo_mercado]    CHAR (1)     NULL,
    [ic_exportacao_tipo_mercado] CHAR (1)     NULL,
    [ic_importacao_tipo_mercado] CHAR (1)     NULL,
    [ic_ipi_tipo_mercado]        CHAR (1)     NULL,
    [ic_icm_tipo_mercado]        CHAR (1)     NULL,
    [ic_moeda_tipo_mercado]      CHAR (1)     NULL,
    [ic_desconto_tipo_mercado]   CHAR (1)     NULL,
    [ic_preco_tipo_mercado]      CHAR (1)     NULL,
    [ic_analise_tipo_mercado]    CHAR (1)     NULL,
    [ic_transportadora]          CHAR (1)     NULL,
    [ic_orcamento_tipo_mercado]  CHAR (1)     NULL,
    [ic_rc_evolucao_consumo]     CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Mercado] PRIMARY KEY CLUSTERED ([cd_tipo_mercado] ASC) WITH (FILLFACTOR = 90)
);

