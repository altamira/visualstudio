CREATE TABLE [dbo].[Cadeia_Valor_Idioma] (
    [cd_cadeia_valor]        INT          NOT NULL,
    [cd_idioma]              INT          NOT NULL,
    [nm_cadeia_valor_idioma] VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Cadeia_Valor_Idioma] PRIMARY KEY CLUSTERED ([cd_cadeia_valor] ASC, [cd_idioma] ASC) WITH (FILLFACTOR = 90)
);

