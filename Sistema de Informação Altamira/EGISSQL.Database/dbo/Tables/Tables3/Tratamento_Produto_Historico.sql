CREATE TABLE [dbo].[Tratamento_Produto_Historico] (
    [cd_tratamento_historico] INT        NOT NULL,
    [dt_tratamento_historico] DATETIME   NULL,
    [cd_tratamento_produto]   INT        NOT NULL,
    [vl_tratamento_Historico] FLOAT (53) NULL,
    [cd_usuario]              INT        NULL,
    [dt_usuario]              DATETIME   NULL,
    CONSTRAINT [PK_Tratamento_Produto_Historico] PRIMARY KEY CLUSTERED ([cd_tratamento_historico] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tratamento_Produto_Historico_Tratamento_Produto] FOREIGN KEY ([cd_tratamento_produto]) REFERENCES [dbo].[Tratamento_Produto] ([cd_tratamento_produto])
);

