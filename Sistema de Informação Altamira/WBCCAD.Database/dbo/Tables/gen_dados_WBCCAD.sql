CREATE TABLE [dbo].[gen_dados_WBCCAD] (
    [Nao_mostrar_compr_especial_gond]  BIT           NOT NULL,
    [Nao_incluir_fechamento_interno]   BIT           NOT NULL,
    [Nao_incluir_plaquetas]            BIT           NOT NULL,
    [Nao_cab_leg_tubula]               BIT           NOT NULL,
    [altura_acima_forcador]            FLOAT (53)    NULL,
    [utilizar_cabos_eletrica]          BIT           NOT NULL,
    [nomenclatura_maquinas_uc]         NVARCHAR (50) NULL,
    [acresc_kcal_uc]                   FLOAT (53)    NULL,
    [Valor_padrao_subida_maquina]      FLOAT (53)    NULL,
    [nao_inc_rel_comprimentos_tubula]  BIT           NOT NULL,
    [Altura_canaleta_tubula]           INT           NULL,
    [altura_minima_incluir_subida]     INT           NULL,
    [inverter_texto_diametros_legenda] BIT           NOT NULL
);

