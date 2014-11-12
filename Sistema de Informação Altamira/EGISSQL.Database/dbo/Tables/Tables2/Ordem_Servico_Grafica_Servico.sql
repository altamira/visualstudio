CREATE TABLE [dbo].[Ordem_Servico_Grafica_Servico] (
    [cd_ordem_servico]    INT          NOT NULL,
    [cd_item_servico]     INT          NOT NULL,
    [cd_servico]          INT          NULL,
    [nm_item_servico]     VARCHAR (60) NULL,
    [ds_item_servico]     TEXT         NULL,
    [qt_item_servico]     FLOAT (53)   NULL,
    [vl_unitario_servico] FLOAT (53)   NULL,
    [vl_total_servico]    FLOAT (53)   NULL,
    [qt_cor_servico]      FLOAT (53)   NULL,
    [nm_obs_item_servico] VARCHAR (60) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Ordem_Servico_Grafica_Servico] PRIMARY KEY CLUSTERED ([cd_ordem_servico] ASC, [cd_item_servico] ASC) WITH (FILLFACTOR = 90)
);

