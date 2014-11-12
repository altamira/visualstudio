CREATE TABLE [dbo].[Documento_Receber_Instrucao] (
    [cd_documento_receber]   INT      NOT NULL,
    [ds_instrucao_documento] TEXT     NULL,
    [cd_usuario]             INT      NULL,
    [dt_usuario]             DATETIME NULL,
    CONSTRAINT [PK_Documento_Receber_Instrucao] PRIMARY KEY CLUSTERED ([cd_documento_receber] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Documento_Receber_Instrucao_Documento_Receber] FOREIGN KEY ([cd_documento_receber]) REFERENCES [dbo].[Documento_Receber] ([cd_documento_receber])
);

