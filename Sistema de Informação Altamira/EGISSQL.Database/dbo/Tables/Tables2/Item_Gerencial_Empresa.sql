CREATE TABLE [dbo].[Item_Gerencial_Empresa] (
    [cd_grupo_gerencial] INT NOT NULL,
    [cd_item_gerencial]  INT NOT NULL,
    CONSTRAINT [PK_Item_Gerencial_Empresa] PRIMARY KEY CLUSTERED ([cd_grupo_gerencial] ASC, [cd_item_gerencial] ASC) WITH (FILLFACTOR = 90)
);

