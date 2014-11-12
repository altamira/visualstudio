CREATE TABLE [dbo].[Plano_MRP_Necessidade] (
    [cd_plano_mrp]            INT          NOT NULL,
    [cd_item_necessidade]     INT          NOT NULL,
    [cd_tipo_produto_projeto] INT          NULL,
    [cd_produto]              INT          NULL,
    [cd_fase_produto]         INT          NULL,
    [qt_item_necessidade]     FLOAT (53)   NULL,
    [cd_requisicao_compra]    INT          NULL,
    [cd_requisicao_interna]   INT          NULL,
    [cd_processo]             INT          NULL,
    [nm_obs_item_necessidade] VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Plano_MRP_Necessidade] PRIMARY KEY CLUSTERED ([cd_plano_mrp] ASC, [cd_item_necessidade] ASC),
    CONSTRAINT [FK_Plano_MRP_Necessidade_Plano_MRP] FOREIGN KEY ([cd_plano_mrp]) REFERENCES [dbo].[Plano_MRP] ([cd_plano_mrp])
);

