CREATE TABLE [dbo].[Consulta_Item_Orcamento_Cat] (
    [cd_consulta]             INT          NULL,
    [cd_item_consulta]        INT          NULL,
    [cd_item_orcamento]       INT          NULL,
    [cd_categoria_orcamento]  INT          NULL,
    [qt_hora_item_orcamento]  FLOAT (53)   NULL,
    [vl_custo_item_orcamento] FLOAT (53)   NULL,
    [nm_obs_item_orcamento]   VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL
);

