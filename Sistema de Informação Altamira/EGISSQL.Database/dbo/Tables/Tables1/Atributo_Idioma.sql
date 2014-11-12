CREATE TABLE [dbo].[Atributo_Idioma] (
    [cd_tabela]          INT          NOT NULL,
    [cd_atributo]        INT          NOT NULL,
    [cd_idioma]          INT          NOT NULL,
    [nm_atributo_idioma] VARCHAR (40) NULL,
    [ds_atributo_idioma] TEXT         NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Atributo_Idioma] PRIMARY KEY CLUSTERED ([cd_tabela] ASC, [cd_atributo] ASC, [cd_idioma] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Atributo_Idioma_Idioma] FOREIGN KEY ([cd_idioma]) REFERENCES [dbo].[Idioma] ([cd_idioma])
);

