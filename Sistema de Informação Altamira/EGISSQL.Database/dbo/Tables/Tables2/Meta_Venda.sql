CREATE TABLE [dbo].[Meta_Venda] (
    [cd_empresa]                INT          NOT NULL,
    [cd_meta_venda]             INT          NOT NULL,
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
    [cd_tipo_mercado]           INT          NULL,
    [qt_venda_imediato_meta]    FLOAT (53)   NULL,
    [qt_meta_venda_mes]         FLOAT (53)   NULL,
    [qt_proposta_imediato_meta] FLOAT (53)   NULL,
    [qt_proposta_mes_meta]      FLOAT (53)   NULL,
    [qt_venda_mes_meta]         FLOAT (53)   NULL,
    CONSTRAINT [PK_Meta_Venda] PRIMARY KEY CLUSTERED ([cd_empresa] ASC, [cd_meta_venda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Meta_Venda_Tipo_Mercado] FOREIGN KEY ([cd_tipo_mercado]) REFERENCES [dbo].[Tipo_Mercado] ([cd_tipo_mercado])
);

