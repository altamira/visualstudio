CREATE TABLE [dbo].[Produto_Estampo_Markup] (
    [cd_produto_estampo]  INT          NULL,
    [cd_item_markup]      INT          NULL,
    [cd_tipo_markup]      INT          NULL,
    [cd_aplicacao_markup] INT          NOT NULL,
    [pc_item_markup]      FLOAT (53)   NULL,
    [vl_item_markup]      FLOAT (53)   NULL,
    [nm_obs_item_markup]  VARCHAR (40) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL
);

