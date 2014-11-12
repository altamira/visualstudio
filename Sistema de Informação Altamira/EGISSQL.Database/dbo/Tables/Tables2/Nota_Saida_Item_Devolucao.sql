CREATE TABLE [dbo].[Nota_Saida_Item_Devolucao] (
    [cd_nota_saida]             INT          NOT NULL,
    [cd_num_formulario_nota]    INT          NULL,
    [cd_item_nota_saida]        INT          NOT NULL,
    [dt_dev_item_nota_saida]    DATETIME     NULL,
    [nm_mot_rest_item_nt_saida] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [qt_dev_item_nota_saida]    FLOAT (53)   NULL
);

