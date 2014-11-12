CREATE TABLE [dbo].[Ordem_Servico_Analista_Item] (
    [cd_ordem_servico]         INT          NOT NULL,
    [cd_item_ordem_servico]    INT          NOT NULL,
    [dt_item_ordem_servico]    DATETIME     NULL,
    [nm_hora_inicio_ordem]     VARCHAR (8)  NULL,
    [nm_hora_fim_ordem]        VARCHAR (8)  NULL,
    [qt_item_normal_ordem]     FLOAT (53)   NULL,
    [qt_item_extra1_ordem]     FLOAT (53)   NULL,
    [qt_item_extra2_ordem]     FLOAT (53)   NULL,
    [qt_item_desloc_ordem]     FLOAT (53)   NULL,
    [nm_item_obs_ordem]        VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_servico]               INT          NULL,
    [nm_hora_intervalo]        VARCHAR (8)  NULL,
    [ds_servico_ordem_servico] TEXT         NULL,
    [vl_servico_ordem_servico] FLOAT (53)   NULL,
    [vl_item_total_servico]    FLOAT (53)   NULL,
    CONSTRAINT [PK_Ordem_Servico_Analista_Item] PRIMARY KEY CLUSTERED ([cd_ordem_servico] ASC, [cd_item_ordem_servico] ASC) WITH (FILLFACTOR = 90)
);

