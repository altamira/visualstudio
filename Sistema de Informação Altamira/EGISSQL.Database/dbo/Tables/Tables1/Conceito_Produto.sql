CREATE TABLE [dbo].[Conceito_Produto] (
    [cd_conceito_produto]       INT          NOT NULL,
    [nm_conceito_produto]       VARCHAR (40) NULL,
    [sg_conceito_produto]       CHAR (10)    NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [qt_ponto_conceito_produto] INT          NULL,
    CONSTRAINT [PK_Conceito_Produto] PRIMARY KEY CLUSTERED ([cd_conceito_produto] ASC) WITH (FILLFACTOR = 90)
);

