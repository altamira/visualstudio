CREATE TABLE [dbo].[Custo_Produto_Historico] (
    [cd_custo_produto_historico] INT      NOT NULL,
    [dt_custo_produto_historico] DATETIME NULL,
    [cd_produto]                 INT      NULL,
    [cd_usuario]                 INT      NULL,
    [dt_usuario]                 DATETIME NULL,
    CONSTRAINT [PK_Custo_Produto_Historico] PRIMARY KEY CLUSTERED ([cd_custo_produto_historico] ASC) WITH (FILLFACTOR = 90)
);

