CREATE TABLE [dbo].[Produto_Autor] (
    [cd_produto]           INT          NOT NULL,
    [cd_produto_autor]     INT          NOT NULL,
    [cd_autor_produto]     INT          NULL,
    [nm_obs_produto_autor] VARCHAR (40) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Produto_Autor] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_produto_autor] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Autor_Autor] FOREIGN KEY ([cd_autor_produto]) REFERENCES [dbo].[Autor] ([cd_autor])
);

