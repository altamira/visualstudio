CREATE TABLE [dbo].[Grupo_Ocorrencia_Grupo_Produto] (
    [cd_grupo_ocorrencia_pedido] INT NOT NULL,
    [cd_grupo_produto]           INT NOT NULL,
    CONSTRAINT [PK_Grupo_Ocorrencia_Grupo_Produto] PRIMARY KEY CLUSTERED ([cd_grupo_ocorrencia_pedido] ASC, [cd_grupo_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Grupo_Ocorrencia_Grupo_Produto_Grupo_Produto] FOREIGN KEY ([cd_grupo_produto]) REFERENCES [dbo].[Grupo_Produto] ([cd_grupo_produto])
);

