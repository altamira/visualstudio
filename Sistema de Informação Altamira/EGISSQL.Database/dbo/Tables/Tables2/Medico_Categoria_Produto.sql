CREATE TABLE [dbo].[Medico_Categoria_Produto] (
    [cd_medico]            INT          NOT NULL,
    [cd_categoria_produto] INT          NOT NULL,
    [nm_obs_categoria]     VARCHAR (40) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Medico_Categoria_Produto] PRIMARY KEY CLUSTERED ([cd_medico] ASC, [cd_categoria_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Medico_Categoria_Produto_Categoria_Produto] FOREIGN KEY ([cd_categoria_produto]) REFERENCES [dbo].[Categoria_Produto] ([cd_categoria_produto])
);

