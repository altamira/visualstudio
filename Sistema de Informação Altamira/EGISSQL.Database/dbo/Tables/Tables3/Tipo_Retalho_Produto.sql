CREATE TABLE [dbo].[Tipo_Retalho_Produto] (
    [cd_tipo_retalho] INT      NOT NULL,
    [cd_produto]      INT      NOT NULL,
    [cd_fase_produto] INT      NOT NULL,
    [cd_usuario]      INT      NULL,
    [dt_usuario]      DATETIME NULL,
    CONSTRAINT [PK_Tipo_Retalho_Produto] PRIMARY KEY CLUSTERED ([cd_tipo_retalho] ASC, [cd_produto] ASC, [cd_fase_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Retalho_Produto_Fase_Produto] FOREIGN KEY ([cd_fase_produto]) REFERENCES [dbo].[Fase_Produto] ([cd_fase_produto])
);

