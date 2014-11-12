CREATE TABLE [dbo].[Produto_Medida] (
    [cd_produto]          INT        NOT NULL,
    [qt_diametro_interno] FLOAT (53) NULL,
    [qt_diametro_externo] FLOAT (53) NULL,
    [cd_usuario]          INT        NULL,
    [dt_usuario]          DATETIME   NULL,
    CONSTRAINT [PK_Produto_Medida] PRIMARY KEY CLUSTERED ([cd_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Medida_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

