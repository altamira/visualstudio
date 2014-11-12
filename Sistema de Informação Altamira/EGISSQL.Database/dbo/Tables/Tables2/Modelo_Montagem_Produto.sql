CREATE TABLE [dbo].[Modelo_Montagem_Produto] (
    [cd_modelo_produto]        INT      NOT NULL,
    [cd_montagem_produto]      INT      NOT NULL,
    [cd_usuario]               INT      NULL,
    [dt_usuario]               DATETIME NULL,
    [cd_ordem_modelo_montagem] INT      NULL,
    CONSTRAINT [PK_Modelo_Montagem_Produto] PRIMARY KEY CLUSTERED ([cd_modelo_produto] ASC, [cd_montagem_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Modelo_Montagem_Produto_Montagem_Produto] FOREIGN KEY ([cd_montagem_produto]) REFERENCES [dbo].[Montagem_Produto] ([cd_montagem_produto])
);

