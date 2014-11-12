CREATE TABLE [dbo].[Consulta_Item_Orcamento_Refrig] (
    [cd_consulta]               INT          NOT NULL,
    [cd_item_consulta]          INT          NOT NULL,
    [cd_item_orcamento]         INT          NOT NULL,
    [cd_item_refrig]            INT          NOT NULL,
    [qt_preparacao_item_refrig] INT          NULL,
    [qt_diametro_item_refrig]   FLOAT (53)   NULL,
    [qt_perimetro_item_refrig]  FLOAT (53)   NULL,
    [cd_maquina]                INT          NULL,
    [nm_obs_item_refrig]        VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [vl_custo_mandrilhadora]    FLOAT (53)   NULL,
    [qt_hora_mandrilhadora]     FLOAT (53)   NULL,
    CONSTRAINT [PK_Consulta_Item_Orcamento_Refrig] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_item_consulta] ASC, [cd_item_orcamento] ASC, [cd_item_refrig] ASC) WITH (FILLFACTOR = 90)
);

