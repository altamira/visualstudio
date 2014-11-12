CREATE TABLE [dbo].[Campanha_Segmentacao] (
    [cd_campanha]         INT      NOT NULL,
    [cd_item_segmentacao] INT      NOT NULL,
    [cd_tipo_segmentacao] INT      NOT NULL,
    [ds_sql_segmentacao]  TEXT     NOT NULL,
    [cd_usuario]          INT      NOT NULL,
    [dt_usuario]          DATETIME NOT NULL,
    CONSTRAINT [PK_Campanha_segmentacao] PRIMARY KEY NONCLUSTERED ([cd_campanha] ASC, [cd_item_segmentacao] ASC) WITH (FILLFACTOR = 90)
);

