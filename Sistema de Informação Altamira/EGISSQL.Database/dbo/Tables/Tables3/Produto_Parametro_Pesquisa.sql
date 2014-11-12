CREATE TABLE [dbo].[Produto_Parametro_Pesquisa] (
    [cd_produto]                    INT        NOT NULL,
    [cd_parametro_pesquisa_produto] INT        NOT NULL,
    [vl_minimo]                     FLOAT (53) NULL,
    [vl_maximo]                     FLOAT (53) NULL,
    [cd_usuario]                    INT        NULL,
    [dt_usuario]                    DATETIME   NULL,
    CONSTRAINT [PK_Produto_Parametro_Pesquisa] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_parametro_pesquisa_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Parametro_Pesquisa_Parametro_Pesquisa_Produto] FOREIGN KEY ([cd_parametro_pesquisa_produto]) REFERENCES [dbo].[Parametro_Pesquisa_Produto] ([cd_parametro_pesquisa_produto])
);

