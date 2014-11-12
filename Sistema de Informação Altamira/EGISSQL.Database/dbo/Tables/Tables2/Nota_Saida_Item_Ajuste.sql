CREATE TABLE [dbo].[Nota_Saida_Item_Ajuste] (
    [cd_nota_saida]         INT        NOT NULL,
    [cd_item_nota_saida]    INT        NOT NULL,
    [qt_item_nota_saida]    FLOAT (53) NULL,
    [vl_unitario_item_nota] FLOAT (53) NULL,
    [vl_total_item]         FLOAT (53) NULL,
    [cd_usuario]            INT        NULL,
    [dt_usuario]            DATETIME   NULL,
    CONSTRAINT [PK_Nota_Saida_Item_Ajuste] PRIMARY KEY CLUSTERED ([cd_nota_saida] ASC, [cd_item_nota_saida] ASC)
);

