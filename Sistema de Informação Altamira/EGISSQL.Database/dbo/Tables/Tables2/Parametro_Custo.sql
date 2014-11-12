CREATE TABLE [dbo].[Parametro_Custo] (
    [cd_empresa]                 INT        NOT NULL,
    [cd_usuario]                 INT        NULL,
    [dt_usuario]                 DATETIME   NULL,
    [ic_parametro_peps_empresa]  CHAR (1)   NULL,
    [ic_exibicao_padrao_prod]    CHAR (1)   NULL,
    [ic_ipi_custo_produto]       CHAR (1)   NULL,
    [pc_desconto_analise_preco]  FLOAT (53) NULL,
    [ic_validar_entrada_manual]  CHAR (1)   NULL,
    [ic_codigo_reg_inventario]   CHAR (1)   NULL,
    [ic_peso_peps]               CHAR (1)   NULL,
    [ic_tipo_calculo_cpv]        CHAR (1)   NULL,
    [ic_cabecalho_relatorio]     CHAR (1)   NULL,
    [qt_casa_decimal_custo]      INT        NULL,
    [ic_analitico_mes_custo]     CHAR (1)   NULL,
    [ic_icms_custo_produto]      CHAR (1)   NULL,
    [ic_rateio_despesa_producao] CHAR (1)   NULL,
    [ic_ociosa_hora_producao]    CHAR (1)   NULL,
    [ic_gera_nf_complemento]     CHAR (1)   NULL,
    [qt_arredondamento]          FLOAT (53) NULL,
    CONSTRAINT [PK_Parametro_Custo] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

