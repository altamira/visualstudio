CREATE TABLE [dbo].[Grupo_Produto_Tecnica_Idioma] (
    [cd_grupo_produto]         INT      NOT NULL,
    [cd_idioma]                INT      NOT NULL,
    [ds_tecnica_grupo_produto] TEXT     NULL,
    [cd_usuario]               INT      NULL,
    [dt_usuario]               DATETIME NULL,
    CONSTRAINT [PK_Grupo_Produto_Tecnica_Idioma] PRIMARY KEY CLUSTERED ([cd_grupo_produto] ASC, [cd_idioma] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Grupo_Produto_Tecnica_Idioma_Idioma] FOREIGN KEY ([cd_idioma]) REFERENCES [dbo].[Idioma] ([cd_idioma])
);

