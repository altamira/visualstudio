CREATE TABLE [dbo].[Propaganda_Idioma] (
    [cd_idioma]            INT      NOT NULL,
    [ds_propaganda_idioma] TEXT     NULL,
    [cd_usuario]           INT      NULL,
    [dt_usuario]           DATETIME NULL,
    [cd_propaganda]        INT      NOT NULL,
    CONSTRAINT [PK_Propaganda_Idioma] PRIMARY KEY CLUSTERED ([cd_idioma] ASC, [cd_propaganda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Propaganda_Idioma_Propaganda] FOREIGN KEY ([cd_propaganda]) REFERENCES [dbo].[Propaganda] ([cd_propaganda])
);

