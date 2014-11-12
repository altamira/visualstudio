CREATE TABLE [dbo].[Aux_Meta_Venda_3] (
    [cd_empresa]                INT          NOT NULL,
    [dt_inicial_meta_venda]     DATETIME     NOT NULL,
    [dt_final_meta_venda]       DATETIME     NOT NULL,
    [vl_venda_imediato_meta]    FLOAT (53)   NULL,
    [vl_venda_mes_meta]         FLOAT (53)   NULL,
    [vl_proposta_imediato_meta] FLOAT (53)   NULL,
    [vl_proposta_mes_meta]      FLOAT (53)   NULL,
    [nm_obs_meta_venda]         VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_padrao_meta_venda]      CHAR (1)     NULL,
    [ic_filtro_loja_meta]       CHAR (1)     NULL,
    [cd_tipo_mercado]           INT          NULL
);

