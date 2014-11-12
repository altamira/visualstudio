CREATE TABLE [dbo].[Documento_Relatorio] (
    [cd_documento_relatorio] INT          NOT NULL,
    [nm_documento_relatorio] VARCHAR (40) NOT NULL,
    [sg_documento_relatorio] CHAR (10)    NULL,
    [ds_documento_relatorio] TEXT         NULL,
    [cd_modulo]              INT          NULL,
    [cd_idioma]              INT          NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Documento_Relatorio] PRIMARY KEY CLUSTERED ([cd_documento_relatorio] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Documento_Relatorio_Idioma] FOREIGN KEY ([cd_idioma]) REFERENCES [dbo].[Idioma] ([cd_idioma])
);

