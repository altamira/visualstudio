CREATE TABLE [dbo].[Produto_Historico] (
    [dt_historico_produto]      DATETIME   NOT NULL,
    [cd_grupo_produto]          INT        NOT NULL,
    [cd_produto]                INT        NOT NULL,
    [vl_historico_produto]      FLOAT (53) NULL,
    [cd_tipo_reajuste]          INT        NULL,
    [cd_tipo_tabela_preco]      INT        NULL,
    [cd_moeda]                  INT        NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    [cd_motivo_reajuste]        INT        NULL,
    [cd_produto_historico]      INT        NOT NULL,
    [ic_tipo_historico_produto] CHAR (1)   NULL,
    CONSTRAINT [PK_Produto_Historico] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_produto_historico] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Historico_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda]),
    CONSTRAINT [FK_Produto_Historico_Tipo_Reajuste] FOREIGN KEY ([cd_tipo_reajuste]) REFERENCES [dbo].[Tipo_Reajuste] ([cd_tipo_reajuste]),
    CONSTRAINT [FK_Produto_Historico_Tipo_Tabela_Preco] FOREIGN KEY ([cd_tipo_tabela_preco]) REFERENCES [dbo].[Tipo_Tabela_Preco] ([cd_tipo_tabela_preco])
);

