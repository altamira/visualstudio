CREATE TABLE [dbo].[Nota_Entrada_Centro_Custo] (
    [cd_nota_centro_custo] INT          NOT NULL,
    [cd_nota_entrada]      INT          NOT NULL,
    [cd_fornecedor]        INT          NOT NULL,
    [cd_operacao_fiscal]   INT          NULL,
    [cd_serie_nota_fiscal] INT          NULL,
    [cd_item_nota_centro]  INT          NULL,
    [cd_centro_custo]      INT          NULL,
    [cd_item_centro_custo] INT          NULL,
    [pc_centro_custo]      FLOAT (53)   NULL,
    [vl_centro_custo]      FLOAT (53)   NULL,
    [nm_obs_centro_custo]  VARCHAR (40) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Nota_Entrada_Centro_Custo] PRIMARY KEY CLUSTERED ([cd_nota_centro_custo] ASC) WITH (FILLFACTOR = 90)
);

