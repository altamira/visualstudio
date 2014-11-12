CREATE TABLE [dbo].[Documento_Receber_Complemento] (
    [cd_documento_receber]     INT        NOT NULL,
    [vl_imposto_documento]     FLOAT (53) NULL,
    [vl_multa_documento]       FLOAT (53) NULL,
    [vl_pagamento_documento]   FLOAT (53) NULL,
    [vl_outros_documento]      FLOAT (53) NULL,
    [ds_complemento_documento] TEXT       NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    CONSTRAINT [PK_Documento_Receber_Complemento] PRIMARY KEY CLUSTERED ([cd_documento_receber] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Documento_Receber_Complemento_Documento_Receber] FOREIGN KEY ([cd_documento_receber]) REFERENCES [dbo].[Documento_Receber] ([cd_documento_receber])
);

