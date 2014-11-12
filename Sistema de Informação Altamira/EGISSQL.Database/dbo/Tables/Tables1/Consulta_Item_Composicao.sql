CREATE TABLE [dbo].[Consulta_Item_Composicao] (
    [cd_consulta]              INT          NOT NULL,
    [cd_item_consulta]         INT          NOT NULL,
    [cd_item_comp_consulta]    INT          NOT NULL,
    [cd_produto]               INT          NULL,
    [nm_fantasia_produto]      VARCHAR (30) NULL,
    [qt_item_comp_consulta]    FLOAT (53)   NULL,
    [vl_item_comp_consulta]    FLOAT (53)   NULL,
    [nm_obs_comp_consulta]     VARCHAR (40) NULL,
    [cd_cor]                   INT          NULL,
    [cd_fase_produto]          INT          NULL,
    [cd_ordem_item_composicao] INT          NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Consulta_Item_Composicao] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_item_consulta] ASC, [cd_item_comp_consulta] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Consulta_Item_Composicao_Fase_Produto] FOREIGN KEY ([cd_fase_produto]) REFERENCES [dbo].[Fase_Produto] ([cd_fase_produto])
);

