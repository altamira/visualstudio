CREATE TABLE [dbo].[Nota_SMO_Item] (
    [cd_nota_smo]              INT          NOT NULL,
    [cd_item_nota_smo]         INT          NOT NULL,
    [cd_item_nota_entrada]     INT          NULL,
    [qt_item_nota_smo]         FLOAT (53)   NULL,
    [nm_produto_item_nota_smo] VARCHAR (40) NULL,
    [cd_unidade_medida]        INT          NULL,
    [vl_unitario_item_smo]     FLOAT (53)   NULL,
    [vl_total_item_smo]        FLOAT (53)   NULL,
    [qt_perda_item_smo]        FLOAT (53)   NULL,
    [nm_obs_item_smo]          VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [pc_ipi_item_nota_smo]     FLOAT (53)   NULL,
    [pc_icms_item_nota_smo]    FLOAT (53)   NULL,
    CONSTRAINT [PK_Nota_SMO_Item] PRIMARY KEY CLUSTERED ([cd_nota_smo] ASC, [cd_item_nota_smo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Nota_SMO_Item_Unidade_Medida] FOREIGN KEY ([cd_unidade_medida]) REFERENCES [dbo].[Unidade_Medida] ([cd_unidade_medida])
);

