CREATE TABLE [dbo].[Produto_Orcamento_Componente] (
    [cd_produto_pai]        INT          NOT NULL,
    [cd_item_produto_orcam] INT          NOT NULL,
    [cd_produto]            INT          NOT NULL,
    [qt_item_produto_orcam] INT          NULL,
    [cd_fase_estoque]       INT          NULL,
    [nm_obs_produto_orcam]  VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Produto_Orcamento_Componente] PRIMARY KEY CLUSTERED ([cd_produto_pai] ASC, [cd_item_produto_orcam] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Orcamento_Componente_Fase_Produto] FOREIGN KEY ([cd_fase_estoque]) REFERENCES [dbo].[Fase_Produto] ([cd_fase_produto]),
    CONSTRAINT [FK_Produto_Orcamento_Componente_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

