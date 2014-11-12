CREATE TABLE [dbo].[Consulta_Item_Lote] (
    [cd_consulta]         INT        NOT NULL,
    [cd_item_consulta]    INT        NOT NULL,
    [cd_lote_produto]     INT        NOT NULL,
    [qt_selecionado_lote] FLOAT (53) NULL,
    [cd_usuario]          INT        NULL,
    [dt_usuario]          DATETIME   NULL,
    CONSTRAINT [PK_Consulta_Item_Lote] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_item_consulta] ASC, [cd_lote_produto] ASC) WITH (FILLFACTOR = 90)
);

