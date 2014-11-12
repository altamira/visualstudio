CREATE TABLE [dbo].[Parametro_Pesquisa_Produto] (
    [cd_parametro_pesquisa_produto] INT          NOT NULL,
    [nm_parametro_pesquisa_produto] VARCHAR (40) NULL,
    [cd_usuario]                    INT          NULL,
    [dt_usuario]                    DATETIME     NULL,
    [cd_unidade_medida]             INT          NULL,
    [cd_metodo_parametro_pesquisa]  INT          NULL,
    CONSTRAINT [PK_Parametro_Pesquisa_Produto] PRIMARY KEY CLUSTERED ([cd_parametro_pesquisa_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parametro_Pesquisa_Produto_Unidade_Medida] FOREIGN KEY ([cd_unidade_medida]) REFERENCES [dbo].[Unidade_Medida] ([cd_unidade_medida])
);

