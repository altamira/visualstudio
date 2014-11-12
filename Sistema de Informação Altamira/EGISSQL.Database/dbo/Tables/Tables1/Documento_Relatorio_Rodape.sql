CREATE TABLE [dbo].[Documento_Relatorio_Rodape] (
    [cd_documento_relatorio] INT      NOT NULL,
    [cd_usuario]             INT      NULL,
    [dt_usuario]             DATETIME NULL,
    CONSTRAINT [PK_Documento_Relatorio_Rodape] PRIMARY KEY CLUSTERED ([cd_documento_relatorio] ASC) WITH (FILLFACTOR = 90)
);

