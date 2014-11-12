CREATE TABLE [dbo].[Nota_Saida_Complemento] (
    [cd_nota_saida]            INT          NOT NULL,
    [cd_item_complemento_nota] INT          NOT NULL,
    [dt_nota_complemento_nota] DATETIME     NULL,
    [nm_obs_complemento_nota]  VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Nota_Saida_Complemento] PRIMARY KEY CLUSTERED ([cd_nota_saida] ASC, [cd_item_complemento_nota] ASC) WITH (FILLFACTOR = 90)
);

