CREATE TABLE [dbo].[Nota_Credito_Item] (
    [cd_nota_credito]          INT          NULL,
    [cd_item_nota_credito]     INT          NULL,
    [cd_nota_saida]            INT          NULL,
    [vl_item_nota_credito]     FLOAT (53)   NULL,
    [nm_item_nota_credito]     VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [nm_item_obs_nota_credito] VARCHAR (40) NULL,
    [cd_documento_receber]     INT          NULL
);

