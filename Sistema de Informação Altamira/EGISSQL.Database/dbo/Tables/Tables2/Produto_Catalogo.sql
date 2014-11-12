CREATE TABLE [dbo].[Produto_Catalogo] (
    [cd_produto]                INT           NOT NULL,
    [cd_produto_catalogo]       INT           NOT NULL,
    [ic_ativo_produto_catalogo] CHAR (1)      NULL,
    [nm_documento_catalogo]     VARCHAR (150) NULL,
    [ds_produto_catalogo]       TEXT          NULL,
    [nm_obs_produto_catalogo]   VARCHAR (40)  NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    CONSTRAINT [PK_Produto_Catalogo] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_produto_catalogo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Catalogo_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

