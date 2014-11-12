CREATE TABLE [dbo].[Documento_Receber_Historico] (
    [cd_documento_receber]   INT          NOT NULL,
    [dt_historico_documento] DATETIME     NOT NULL,
    [cd_forma_cobranca]      INT          NULL,
    [nm_historico_documento] VARCHAR (40) NULL,
    [ds_historico_documento] TEXT         NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Documento_Receber_Historico] PRIMARY KEY CLUSTERED ([cd_documento_receber] ASC, [dt_historico_documento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Documento_Receber_Historico_Documento_Receber] FOREIGN KEY ([cd_documento_receber]) REFERENCES [dbo].[Documento_Receber] ([cd_documento_receber]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_Documento_Receber_Historico_Forma_Cobranca] FOREIGN KEY ([cd_forma_cobranca]) REFERENCES [dbo].[Forma_Cobranca] ([cd_forma_cobranca])
);

