CREATE TABLE [dbo].[CPV_Produto] (
    [cd_cpv_produto]          INT          NOT NULL,
    [dt_base_cpv_produto]     DATETIME     NULL,
    [cd_moeda]                INT          NULL,
    [cd_produto]              INT          NULL,
    [cd_cliente]              INT          NULL,
    [cd_vendedor]             INT          NULL,
    [cd_grupo_produto]        INT          NULL,
    [cd_categoria_produto]    INT          NULL,
    [qt_cpv_produto]          FLOAT (53)   NULL,
    [vl_unitario_cpv_produto] FLOAT (53)   NULL,
    [vl_total_cpv_produto]    FLOAT (53)   NULL,
    [vl_custo_cpv_produto]    FLOAT (53)   NULL,
    [vl_custo_total_cpv]      FLOAT (53)   NULL,
    [vl_medio_cpv_produto]    FLOAT (53)   NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [nm_obs_cpv_produto]      VARCHAR (40) NULL,
    CONSTRAINT [PK_CPV_Produto] PRIMARY KEY CLUSTERED ([cd_cpv_produto] ASC) WITH (FILLFACTOR = 90)
);

