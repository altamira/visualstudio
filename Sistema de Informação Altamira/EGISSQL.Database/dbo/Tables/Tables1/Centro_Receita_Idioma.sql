CREATE TABLE [dbo].[Centro_Receita_Idioma] (
    [cd_centro_receita]        INT          NOT NULL,
    [cd_idioma]                INT          NOT NULL,
    [nm_centro_receita_idioma] VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Centro_Receita_Idioma] PRIMARY KEY CLUSTERED ([cd_centro_receita] ASC, [cd_idioma] ASC) WITH (FILLFACTOR = 90)
);

