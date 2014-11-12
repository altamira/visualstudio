CREATE TABLE [dbo].[Produto_Idioma] (
    [cd_produto]        INT          NOT NULL,
    [cd_idioma]         INT          NOT NULL,
    [nm_produto_idioma] VARCHAR (50) NOT NULL,
    [ds_produto_idioma] TEXT         NULL,
    [cd_usuario]        INT          NOT NULL,
    [dt_usuario]        DATETIME     NOT NULL
);

