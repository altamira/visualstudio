CREATE TABLE [dbo].[Ordem_Servico_Grafica_Produto] (
    [cd_ordem_servico]      INT          NOT NULL,
    [cd_item_ordem_servico] INT          NOT NULL,
    [cd_produto]            INT          NULL,
    [qt_item_produto]       FLOAT (53)   NULL,
    [vl_unitario_produto]   FLOAT (53)   NULL,
    [vl_total_produto]      FLOAT (53)   NULL,
    [nm_obs_item_produto]   VARCHAR (60) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [qt_formato_1]          FLOAT (53)   NULL,
    [qt_formato_2]          FLOAT (53)   NULL,
    [nm_produto_ordem]      VARCHAR (80) NULL,
    [vl_produto]            FLOAT (53)   NULL,
    [cd_grupo_produto]      INT          NULL,
    [vl_digitado]           FLOAT (53)   NULL,
    CONSTRAINT [PK_Ordem_Servico_Grafica_Produto] PRIMARY KEY CLUSTERED ([cd_ordem_servico] ASC, [cd_item_ordem_servico] ASC) WITH (FILLFACTOR = 90)
);

