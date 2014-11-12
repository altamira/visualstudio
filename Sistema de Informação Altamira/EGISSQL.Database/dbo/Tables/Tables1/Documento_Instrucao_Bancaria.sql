CREATE TABLE [dbo].[Documento_Instrucao_Bancaria] (
    [cd_doc_instrucao_banco]    INT          NOT NULL,
    [dt_instrucao_banco]        DATETIME     NULL,
    [ic_emissao_instrucao_banc] CHAR (1)     NULL,
    [ic_envio_instrucao_banco]  CHAR (1)     NULL,
    [dt_cancelamento_instrucao] DATETIME     NULL,
    [nm_cancelamento_instrucao] VARCHAR (30) NULL,
    [ds_instrucao_banco]        TEXT         NULL,
    [cd_documento_receber]      INT          NULL,
    [cd_banco]                  INT          NULL,
    [ic_envia_instrucao_banco]  CHAR (1)     NULL,
    [dt_cancel_instrucao_banco] DATETIME     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_banco_documento_receb]  VARCHAR (50) NULL,
    [cd_banco_documento_recebe] VARCHAR (50) NULL,
    CONSTRAINT [PK_Documento_Instrucao_Bancaria] PRIMARY KEY CLUSTERED ([cd_doc_instrucao_banco] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Documento_Instrucao_Bancaria_Documento_Receber] FOREIGN KEY ([cd_documento_receber]) REFERENCES [dbo].[Documento_Receber] ([cd_documento_receber])
);

