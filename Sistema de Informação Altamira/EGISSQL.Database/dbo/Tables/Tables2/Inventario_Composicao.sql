CREATE TABLE [dbo].[Inventario_Composicao] (
    [cd_inventario]            INT          NOT NULL,
    [cd_item_inventario]       INT          NOT NULL,
    [cd_controle_inventario]   INT          NULL,
    [cd_planta]                INT          NULL,
    [cd_local_inventario]      INT          NULL,
    [cd_produto]               INT          NULL,
    [cd_fase_produto]          INT          NULL,
    [nm_produto_inventario]    VARCHAR (40) NULL,
    [cd_unidade_medida]        INT          NULL,
    [qt_item_inventario]       FLOAT (53)   NULL,
    [qt_consig_inventario]     FLOAT (53)   NULL,
    [qt_1cont_item_inventario] FLOAT (53)   NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_usuario]               INT          NULL,
    [ic_etiq_item_inventario]  CHAR (1)     NULL,
    [ic_relat_item_inventario] CHAR (1)     NULL,
    [qt_3cont_item_inventario] FLOAT (53)   NULL,
    [qt_2cont_item_inventario] FLOAT (53)   NULL,
    CONSTRAINT [PK_Inventario_Composicao] PRIMARY KEY CLUSTERED ([cd_inventario] ASC, [cd_item_inventario] ASC) WITH (FILLFACTOR = 90)
);

