CREATE TABLE [dbo].[Produto_Sinonimo] (
    [cd_produto]          INT          NOT NULL,
    [cd_produto_sinonimo] INT          NOT NULL,
    [nm_produto_sinonimo] VARCHAR (50) NULL,
    [ds_produto_sinonimo] TEXT         NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Produto_Sinonimo] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_produto_sinonimo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Sinonimo_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

