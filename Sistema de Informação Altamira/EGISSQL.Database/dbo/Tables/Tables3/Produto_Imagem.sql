CREATE TABLE [dbo].[Produto_Imagem] (
    [cd_produto]             INT           NOT NULL,
    [cd_produto_imagem]      INT           NOT NULL,
    [nm_imagem_produto]      VARCHAR (100) NULL,
    [cd_usuario]             INT           NULL,
    [dt_usuario]             DATETIME      NULL,
    [cd_tipo_imagem_produto] INT           NULL,
    CONSTRAINT [PK_Produto_Imagem] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_produto_imagem] ASC) WITH (FILLFACTOR = 90)
);

