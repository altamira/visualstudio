CREATE TABLE [dbo].[Item_Grupo_Composicao] (
    [cd_item_comp]        INT          NOT NULL,
    [cd_grupo_composicao] INT          NOT NULL,
    [nm_item_comp]        VARCHAR (20) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Item_Grupo_Composicao] PRIMARY KEY CLUSTERED ([cd_item_comp] ASC, [cd_grupo_composicao] ASC) WITH (FILLFACTOR = 90)
);

