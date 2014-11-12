CREATE TABLE [dbo].[Documento_Receber_Duplicata] (
    [cd_documento_receber] INT      NOT NULL,
    [cd_usuario_selecao]   INT      NOT NULL,
    [cd_usuario]           INT      NULL,
    [dt_usuario]           DATETIME NULL,
    CONSTRAINT [PK_Documento_Receber_Duplicata] PRIMARY KEY CLUSTERED ([cd_documento_receber] ASC, [cd_usuario_selecao] ASC)
);

