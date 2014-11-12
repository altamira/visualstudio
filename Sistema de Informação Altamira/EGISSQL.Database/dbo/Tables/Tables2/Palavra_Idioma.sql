CREATE TABLE [dbo].[Palavra_Idioma] (
    [cd_palavra]        INT           NOT NULL,
    [cd_idioma]         INT           NOT NULL,
    [nm_palavra_idioma] VARCHAR (100) NOT NULL,
    [ds_palavra_idioma] TEXT          NULL,
    [cd_usuario]        INT           NULL,
    [dt_usuario]        DATETIME      NULL,
    CONSTRAINT [PK_Palavra_Idioma] PRIMARY KEY CLUSTERED ([cd_palavra] ASC, [cd_idioma] ASC) WITH (FILLFACTOR = 90)
);

