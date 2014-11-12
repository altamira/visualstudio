CREATE TABLE [dbo].[Consulta_Item_Montagem] (
    [cd_consulta]               INT          NOT NULL,
    [cd_item_consulta]          INT          NOT NULL,
    [cd_montagem_produto]       INT          NULL,
    [cd_item_montagem_produto]  INT          NULL,
    [nm_item_montagem_consulta] VARCHAR (60) NULL,
    [nm_item_fantasia_consulta] VARCHAR (30) NULL,
    [ds_item_montagem_consulta] TEXT         NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Consulta_Item_Montagem] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_item_consulta] ASC) WITH (FILLFACTOR = 90)
);

