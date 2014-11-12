CREATE TABLE [dbo].[Produto_Opiniao] (
    [cd_produto]          INT          NOT NULL,
    [dt_produto_opiniao]  DATETIME     NOT NULL,
    [cd_conceito_produto] INT          NULL,
    [nm_produto_opiniao]  VARCHAR (40) NULL,
    [ds_produto_opiniao]  TEXT         NULL,
    [cd_cliente]          INT          NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Produto_Opiniao] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [dt_produto_opiniao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Opiniao_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente])
);

