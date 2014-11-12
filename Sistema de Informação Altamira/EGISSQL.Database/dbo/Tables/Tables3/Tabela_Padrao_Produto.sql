CREATE TABLE [dbo].[Tabela_Padrao_Produto] (
    [cd_processo_padrao]        INT      NOT NULL,
    [cd_produto_processo_padra] INT      NOT NULL,
    [cd_serie_produto]          INT      NULL,
    [cd_grupo_produto]          INT      NULL,
    [cd_sub_produto_especial]   INT      NULL,
    [cd_tipo_montagem]          INT      NULL,
    [cd_usuario]                INT      NULL,
    [dt_usuario]                DATETIME NULL,
    CONSTRAINT [PK_Tabela_Padrao_Produto] PRIMARY KEY CLUSTERED ([cd_processo_padrao] ASC, [cd_produto_processo_padra] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tabela_Padrao_Produto_Grupo_Produto] FOREIGN KEY ([cd_grupo_produto]) REFERENCES [dbo].[Grupo_Produto] ([cd_grupo_produto]),
    CONSTRAINT [FK_Tabela_Padrao_Produto_Serie_Produto] FOREIGN KEY ([cd_serie_produto]) REFERENCES [dbo].[Serie_Produto] ([cd_serie_produto]),
    CONSTRAINT [FK_Tabela_Padrao_Produto_Sub_Produto_Especial] FOREIGN KEY ([cd_sub_produto_especial]) REFERENCES [dbo].[Sub_Produto_Especial] ([cd_sub_produto_especial]),
    CONSTRAINT [FK_Tabela_Padrao_Produto_Tipo_Montagem] FOREIGN KEY ([cd_tipo_montagem]) REFERENCES [dbo].[Tipo_Montagem] ([cd_tipo_montagem])
);

