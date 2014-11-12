CREATE TABLE [dbo].[Item_Serie_Produto_Componente] (
    [cd_item_serie_prod_compon] INT          NOT NULL,
    [nm_item_serie_prod_compon] VARCHAR (40) NOT NULL,
    [sg_item_serie_prod_compon] CHAR (10)    NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    CONSTRAINT [PK_Item_Serie_Produto_Componente] PRIMARY KEY CLUSTERED ([cd_item_serie_prod_compon] ASC) WITH (FILLFACTOR = 90)
);

