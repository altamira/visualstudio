CREATE TABLE [dbo].[Produto_Apresentacao] (
    [cd_produto]      INT      NOT NULL,
    [cd_apresentacao] INT      NOT NULL,
    [cd_usuario]      INT      NULL,
    [dt_usuario]      DATETIME NULL,
    CONSTRAINT [PK_Produto_Apresentacao] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_apresentacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Apresentacao_Apresentacao] FOREIGN KEY ([cd_apresentacao]) REFERENCES [dbo].[Apresentacao] ([cd_apresentacao])
);

