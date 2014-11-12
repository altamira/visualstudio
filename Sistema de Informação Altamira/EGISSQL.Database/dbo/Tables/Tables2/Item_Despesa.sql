CREATE TABLE [dbo].[Item_Despesa] (
    [cd_item_despesa] INT          NOT NULL,
    [nm_item_despesa] VARCHAR (30) NOT NULL,
    [sg_item_despesa] CHAR (10)    NOT NULL,
    [cd_usuario]      INT          NOT NULL,
    [dt_usuario]      DATETIME     NOT NULL,
    CONSTRAINT [PK_Item_Despesa] PRIMARY KEY CLUSTERED ([cd_item_despesa] ASC) WITH (FILLFACTOR = 90)
);

