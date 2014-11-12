CREATE TABLE [dbo].[Consulta_Item_Orcamento_Proposta] (
    [cd_consulta]               INT        NOT NULL,
    [cd_item_consulta]          INT        NOT NULL,
    [qt_peso_acabado_manifold]  FLOAT (53) NULL,
    [qt_peso_acabado_hothalf]   FLOAT (53) NULL,
    [vl_frete_manifold]         FLOAT (53) NULL,
    [vl_frete_hothalf]          FLOAT (53) NULL,
    [vl_venda_sugerido]         FLOAT (53) NULL,
    [ds_obs_orcamento_proposta] TEXT       NULL,
    CONSTRAINT [PK_Consulta_Item_Orcamento_Proposta] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_item_consulta] ASC) WITH (FILLFACTOR = 90)
);

