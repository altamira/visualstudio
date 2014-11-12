CREATE TABLE [dbo].[Consulta_Item_REPNET] (
    [cd_consulta]        INT      NOT NULL,
    [cd_item_consulta]   INT      NOT NULL,
    [dt_problema]        DATETIME NULL,
    [dt_recepcao_repnet] DATETIME NULL,
    CONSTRAINT [PK_Consulta_Item_REPNET] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_item_consulta] ASC) WITH (FILLFACTOR = 90)
);

