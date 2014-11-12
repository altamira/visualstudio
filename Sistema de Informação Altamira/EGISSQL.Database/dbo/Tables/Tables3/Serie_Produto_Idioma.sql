CREATE TABLE [dbo].[Serie_Produto_Idioma] (
    [cd_serie_produto]        INT          NOT NULL,
    [cd_idioma]               INT          NOT NULL,
    [nm_serie_produto_idioma] VARCHAR (60) COLLATE SQL_Latin1_General_CP1250_CI_AS NULL,
    [cd_usuario]              INT          NOT NULL,
    [dt_usuario]              DATETIME     NOT NULL,
    CONSTRAINT [PK_Serie_Produto_Idioma] PRIMARY KEY CLUSTERED ([cd_serie_produto] ASC, [cd_idioma] ASC) WITH (FILLFACTOR = 90)
);

