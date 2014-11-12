CREATE TABLE [dbo].[TIPO_RELATORIO_IDIOMA] (
    [cd_tipo_relatorio_idioma] INT           NOT NULL,
    [nm_titulo_relatorio]      VARCHAR (100) NULL,
    [nm_aviso_relatorio]       VARCHAR (100) NULL,
    [cd_idioma]                INT           NULL,
    [cd_usuario]               INT           NULL,
    [dt_usuario]               DATETIME      NULL,
    [ds_tipo_relatorio_idioma] TEXT          NULL,
    CONSTRAINT [PK_TIPO_RELATORIO_IDIOMA] PRIMARY KEY CLUSTERED ([cd_tipo_relatorio_idioma] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_TIPO_RELATORIO_IDIOMA_Idioma] FOREIGN KEY ([cd_idioma]) REFERENCES [dbo].[Idioma] ([cd_idioma])
);

