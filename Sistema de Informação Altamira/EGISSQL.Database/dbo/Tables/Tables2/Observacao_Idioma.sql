CREATE TABLE [dbo].[Observacao_Idioma] (
    [cd_observacao_idioma]    INT      NOT NULL,
    [nm_observacao_documento] TEXT     NULL,
    [nm_observacao_inferior]  TEXT     NULL,
    [nm_agradecimento]        TEXT     NULL,
    [cd_idioma]               INT      NULL,
    [cd_usuario]              INT      NULL,
    [dt_usuario]              DATETIME NULL,
    [nm_titulo_relatorio]     TEXT     NULL,
    CONSTRAINT [PK_Observacao_Idioma] PRIMARY KEY CLUSTERED ([cd_observacao_idioma] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Observacao_Idioma_Idioma] FOREIGN KEY ([cd_idioma]) REFERENCES [dbo].[Idioma] ([cd_idioma])
);

