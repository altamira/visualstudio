CREATE TABLE [dbo].[Movimento_Estoque_Composicao] (
    [cd_movimento_estoque]      INT        NULL,
    [cd_item_movimento_estoque] INT        NULL,
    [qt_movimento_estoque_comp] FLOAT (53) NULL,
    [vl_custo_mov_estoque_comp] FLOAT (53) NULL
);


GO
CREATE NONCLUSTERED INDEX [pk_Movimento_Estoque_Composicao]
    ON [dbo].[Movimento_Estoque_Composicao]([cd_movimento_estoque] ASC) WITH (FILLFACTOR = 90);

