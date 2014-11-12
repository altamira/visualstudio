CREATE TABLE [dbo].[Recibo_Item] (
    [cd_recibo]            INT      NOT NULL,
    [cd_item_recibo]       INT      NOT NULL,
    [cd_observacao_recibo] INT      NULL,
    [cd_usuario]           INT      NULL,
    [dt_usuario]           DATETIME NULL,
    CONSTRAINT [PK_Recibo_Item] PRIMARY KEY CLUSTERED ([cd_recibo] ASC, [cd_item_recibo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Recibo_Item_Observacao_Recibo] FOREIGN KEY ([cd_observacao_recibo]) REFERENCES [dbo].[Observacao_Recibo] ([cd_observacao_recibo])
);

