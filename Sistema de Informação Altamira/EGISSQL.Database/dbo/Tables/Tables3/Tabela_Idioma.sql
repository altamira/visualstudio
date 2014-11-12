CREATE TABLE [dbo].[Tabela_Idioma] (
    [cd_tabela]        INT           NOT NULL,
    [cd_idioma]        INT           NOT NULL,
    [nm_tabela_idioma] VARCHAR (100) NULL,
    [ds_tabela_idioma] TEXT          NULL,
    [cd_usuario]       INT           NULL,
    [dt_usuario]       DATETIME      NULL,
    CONSTRAINT [PK_Tabela_Idioma] PRIMARY KEY CLUSTERED ([cd_tabela] ASC, [cd_idioma] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tabela_Idioma_Idioma] FOREIGN KEY ([cd_idioma]) REFERENCES [dbo].[Idioma] ([cd_idioma])
);

