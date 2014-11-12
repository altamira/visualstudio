CREATE TABLE [dbo].[Consulta_Item_Observacao] (
    [cd_consulta]          INT        NOT NULL,
    [cd_item_consulta]     INT        NOT NULL,
    [cd_consulta_item_obs] INT        NOT NULL,
    [dt_item_observacao]   DATETIME   NOT NULL,
    [ds_produto_item_obs]  TEXT       NOT NULL,
    [vl_lista_item_obs]    FLOAT (53) NOT NULL,
    [vl_unitario_item_obs] FLOAT (53) NOT NULL,
    [cd_usuario]           INT        NOT NULL,
    [dt_usuario]           DATETIME   NOT NULL,
    CONSTRAINT [PK_Consulta_Item_Observacao] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_item_consulta] ASC, [cd_consulta_item_obs] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Consulta_Item_Observacao_Consulta_Itens] FOREIGN KEY ([cd_consulta], [cd_item_consulta]) REFERENCES [dbo].[Consulta_Itens] ([cd_consulta], [cd_item_consulta]) NOT FOR REPLICATION
);

