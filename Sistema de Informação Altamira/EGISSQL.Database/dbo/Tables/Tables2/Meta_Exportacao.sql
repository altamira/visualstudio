CREATE TABLE [dbo].[Meta_Exportacao] (
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
    CONSTRAINT [PK_Meta_Exportacao] PRIMARY KEY CLUSTERED ([cd_empresa] ASC, [dt_inicial_meta_venda] ASC, [dt_final_meta_venda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Meta_Exportacao_Empresa] FOREIGN KEY ([cd_empresa]) REFERENCES [dbo].[Empresa] ([cd_empresa])
);

