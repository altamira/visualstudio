CREATE TABLE [dbo].[Serie_Produto_Componente_HotHalf] (
    [cd_serie_produto]      INT      NOT NULL,
    [cd_tipo_serie_produto] INT      NOT NULL,
    [cd_item_componente]    INT      NOT NULL,
    [cd_produto]            INT      NULL,
    [qt_componente_hothalf] INT      NULL,
    [cd_usuario]            INT      NULL,
    [dt_usuario]            DATETIME NULL,
    CONSTRAINT [PK_Serie_Produto_Componente_HotHalf] PRIMARY KEY CLUSTERED ([cd_serie_produto] ASC, [cd_tipo_serie_produto] ASC, [cd_item_componente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Serie_Produto_Componente_HotHalf_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

