CREATE TABLE [dbo].[Funcao_Idioma] (
    [cd_funcao]        INT          NOT NULL,
    [cd_idioma]        INT          NOT NULL,
    [nm_funcao_idioma] VARCHAR (40) NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Funcao_Idioma] PRIMARY KEY CLUSTERED ([cd_funcao] ASC, [cd_idioma] ASC) WITH (FILLFACTOR = 90)
);

