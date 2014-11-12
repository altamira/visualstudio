CREATE TABLE [dbo].[Produto_Composicao_Agrupamento] (
    [cd_produto_pai]         INT        NOT NULL,
    [cd_agrupamento_produto] INT        NOT NULL,
    [cd_minimo_componentes]  FLOAT (53) NULL,
    [cd_maximo_componentes]  FLOAT (53) NULL,
    CONSTRAINT [PK_Produto_Composicao_Agrupamento] PRIMARY KEY CLUSTERED ([cd_produto_pai] ASC, [cd_agrupamento_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Composicao_Agrupamento_Produto] FOREIGN KEY ([cd_produto_pai]) REFERENCES [dbo].[Produto] ([cd_produto])
);

