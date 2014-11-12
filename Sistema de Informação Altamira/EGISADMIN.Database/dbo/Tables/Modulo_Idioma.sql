CREATE TABLE [dbo].[Modulo_Idioma] (
    [cd_modulo]        INT          NOT NULL,
    [cd_idioma]        INT          NOT NULL,
    [nm_modulo_idioma] VARCHAR (40) NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Modulo_Idioma] PRIMARY KEY CLUSTERED ([cd_modulo] ASC, [cd_idioma] ASC) WITH (FILLFACTOR = 90)
);

