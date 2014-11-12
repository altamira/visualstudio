CREATE TABLE [dbo].[Item_Plano_Teste] (
    [cd_plano_teste]       INT      NOT NULL,
    [cd_grupo_plano_teste] INT      NOT NULL,
    [cd_item_plano_teste]  INT      NOT NULL,
    [ds_item_plano_teste]  TEXT     NULL,
    [ic_nivel_plano_teste] CHAR (1) NULL,
    CONSTRAINT [PK_Item_Plano_Teste] PRIMARY KEY CLUSTERED ([cd_plano_teste] ASC, [cd_grupo_plano_teste] ASC, [cd_item_plano_teste] ASC) WITH (FILLFACTOR = 90)
);

