CREATE TABLE [dbo].[Grupo_Produto_Garantia] (
    [cd_grupo_produto]          INT      NOT NULL,
    [ds_garantia_grupo_produto] TEXT     NULL,
    [cd_usuario]                INT      NULL,
    [dt_usuario]                DATETIME NULL,
    CONSTRAINT [PK_Grupo_Produto_Garantia] PRIMARY KEY CLUSTERED ([cd_grupo_produto] ASC) WITH (FILLFACTOR = 90)
);

