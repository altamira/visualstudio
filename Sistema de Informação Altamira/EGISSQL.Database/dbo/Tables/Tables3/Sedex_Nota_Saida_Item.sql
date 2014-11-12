CREATE TABLE [dbo].[Sedex_Nota_Saida_Item] (
    [cd_sedex_nota_saida]           INT          NULL,
    [cd_item_sedex_nota_saida]      INT          NULL,
    [cd_nota_saida]                 INT          NULL,
    [qt_peso_item_sedex_nota_saida] FLOAT (53)   NULL,
    [vl_custo_sedex_nota_saida]     FLOAT (53)   NULL,
    [nm_obs_item_sedex_nota_saida]  VARCHAR (40) NULL,
    [cd_usuario]                    INT          NULL,
    [dt_usuario]                    DATETIME     NULL
);

