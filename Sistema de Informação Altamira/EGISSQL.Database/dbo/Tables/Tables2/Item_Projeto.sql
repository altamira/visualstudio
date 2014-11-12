CREATE TABLE [dbo].[Item_Projeto] (
    [cd_projeto]         INT       NOT NULL,
    [cd_item_projeto]    INT       NOT NULL,
    [cd_produto]         CHAR (15) NOT NULL,
    [qt_projeto]         INT       NOT NULL,
    [qt_vias_manifold]   INT       NULL,
    [qt_niveis_manifold] INT       NULL,
    [ic_massa_manifold]  CHAR (1)  NULL,
    [cd_tipo_manifold]   INT       NULL,
    [cd_usuario]         INT       NULL,
    [dt_usuario]         DATETIME  NULL,
    CONSTRAINT [PK_Item_Projeto] PRIMARY KEY NONCLUSTERED ([cd_projeto] ASC, [cd_item_projeto] ASC) WITH (FILLFACTOR = 90)
);

