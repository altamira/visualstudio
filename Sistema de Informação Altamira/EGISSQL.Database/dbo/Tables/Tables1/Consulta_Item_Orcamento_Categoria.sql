CREATE TABLE [dbo].[Consulta_Item_Orcamento_Categoria] (
    [cd_consulta]             INT          NOT NULL,
    [cd_item_consulta]        INT          NOT NULL,
    [cd_item_orcamento]       INT          NOT NULL,
    [cd_categoria_orcamento]  INT          NOT NULL,
    [qt_hora_item_orcamento]  FLOAT (53)   NULL,
    [vl_custo_item_orcamento] FLOAT (53)   NULL,
    [nm_obs_item_orcamento]   VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Consulta_Item_Orcamento_Categoria] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_item_consulta] ASC, [cd_item_orcamento] ASC, [cd_categoria_orcamento] ASC) WITH (FILLFACTOR = 90)
);

