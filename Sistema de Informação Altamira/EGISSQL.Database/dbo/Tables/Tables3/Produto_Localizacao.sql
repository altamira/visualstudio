CREATE TABLE [dbo].[Produto_Localizacao] (
    [cd_produto]               INT          NOT NULL,
    [cd_grupo_localizacao]     INT          NOT NULL,
    [cd_item_localizacao]      INT          NOT NULL,
    [qt_posicao_localizacao]   VARCHAR (15) NOT NULL,
    [cd_produto_localizacao_p] INT          NULL,
    [cd_usuario]               INT          NOT NULL,
    [dt_usuario]               DATETIME     NOT NULL,
    [cd_fase_produto]          INT          NULL,
    [cd_produto_endereco]      INT          NULL
);

