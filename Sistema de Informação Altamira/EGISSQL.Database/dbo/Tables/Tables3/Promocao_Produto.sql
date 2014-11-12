CREATE TABLE [dbo].[Promocao_Produto] (
    [cd_promocao]          INT        NOT NULL,
    [cd_produto]           INT        NOT NULL,
    [vl_promocao_produto]  FLOAT (53) NULL,
    [pc_promocao_desconto] FLOAT (53) NULL,
    [vl_produto]           FLOAT (53) NULL,
    [cd_usuario]           INT        NULL,
    [dt_usuario]           DATETIME   NULL,
    CONSTRAINT [PK_Promocao_Produto] PRIMARY KEY CLUSTERED ([cd_promocao] ASC, [cd_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Promocao_Produto_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

