CREATE TABLE [dbo].[Produto_Endereco] (
    [cd_produto]               INT          NOT NULL,
    [cd_fase_produto]          INT          NOT NULL,
    [qt_maximo_estoque]        FLOAT (53)   NULL,
    [qt_saldo_atual_estoque]   FLOAT (53)   NULL,
    [qt_saldo_reserva_estoque] FLOAT (53)   NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_produto_endereco]      INT          NOT NULL,
    [nm_endereco]              VARCHAR (30) NULL,
    CONSTRAINT [PK_Produto_Endereco] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_fase_produto] ASC, [cd_produto_endereco] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Endereco_Fase_Produto] FOREIGN KEY ([cd_fase_produto]) REFERENCES [dbo].[Fase_Produto] ([cd_fase_produto])
);

