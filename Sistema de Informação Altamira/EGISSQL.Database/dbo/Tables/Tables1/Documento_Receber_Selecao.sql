CREATE TABLE [dbo].[Documento_Receber_Selecao] (
    [cd_documento_receber] INT      NOT NULL,
    [cd_usuario]           INT      NULL,
    [dt_usuario]           DATETIME NULL,
    CONSTRAINT [PK_Documento_Receber_Selecao] PRIMARY KEY CLUSTERED ([cd_documento_receber] ASC) WITH (FILLFACTOR = 90)
);

